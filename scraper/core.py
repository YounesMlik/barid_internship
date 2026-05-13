from playwright.sync_api import sync_playwright, Page, BrowserContext
from datetime import date, timedelta
from typing import Callable, Any, Iterable

LOGIN_URL = "http://appsmi02.barid.ma/APGPM/default.aspx"
MAX_ATTEMPTS = 100

type OnError = Callable[[int, Exception], None]


def login(page: Page) -> None:
    page.goto(LOGIN_URL)
    page.fill("#Connect1_FullName", "11106")
    page.fill("#Connect1_Password", "11106")
    page.click("#Connect1_Btn_Connexion")


def date_range(start: date, end: date):
    step = 1 if start <= end else -1
    for i in range(0, (end - start).days + step, step):
        yield start + timedelta(days=i)


def default_on_error(attempt: int, e: Exception):
    print(f"attempt {attempt + 1} failed: {e}")


def with_retry(
    fn: Callable[..., Any],
    on_error: OnError,
    max_attempts: int,
):
    def wrapper(*args: Any, **kwargs: Any):
        last_exc = None
        for attempt in range(max_attempts):
            try:
                return fn(*args, **kwargs)
            except Exception as e:
                last_exc = e
                on_error(attempt, e)
        raise RuntimeError(f"Failed after {max_attempts} attempts") from last_exc

    return wrapper


def retry_with_resource(
    resource: Any,
    acquire: Callable[[], Any],
    action: Callable[[Any], None],
    release: Callable[[Any], None],
    on_error: OnError,
    max_attempts: int,
):
    for attempt in range(max_attempts):
        try:
            action(resource)
            return resource
        except Exception as e:
            on_error(attempt, e)
            release(resource)
            resource = acquire()
    return resource


def run_workflow(
    init_page: Callable[[BrowserContext], Page],
    task: Callable[[Page, Any], None],
    items: Iterable[Any],
    headless: bool = True,
    timeout: int = 10_000,  # in ms
    max_attempts: int = MAX_ATTEMPTS,
    stateless: bool = False,
    on_error: OnError = default_on_error,
):
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=headless)
        context = browser.new_context()
        context.set_default_timeout(timeout)
        acquire = with_retry(
            init_page,
            max_attempts=max_attempts,
            on_error=on_error,
        )
        page = acquire(context)
        for item in items:
            if stateless:
                page.close()
                page = acquire(context)

            page = retry_with_resource(
                resource=page,
                acquire=lambda: acquire(context),
                action=lambda p: task(p, item),
                release=lambda p: p.close(),
                max_attempts=max_attempts,
                on_error=on_error,
            )
        browser.close()
