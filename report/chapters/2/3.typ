#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node, shapes


The absence of a formal application programming interface (API) for data extraction from Barid Al-Maghrib’s operational systems necessitated the design of a custom web automation pipeline. This pipeline is responsible for extracting structured data from web-based interfaces that were originally designed for human interaction rather than machine-to-machine communication.

The chosen approach is based on Robotic Process Automation (RPA), implemented using the Playwright framework for Python. This enables the simulation of user interactions such as navigation, form submission, and data extraction from dynamic web pages.

=== Choice of Playwright Framework

Playwright was selected as the primary automation tool due to its ability to:

- Handle modern dynamic web applications;
- Support multiple browser engines (Chromium, Firefox, WebKit);
- Manage persistent sessions and authentication states;
- Interact with JavaScript-rendered content;
- Provide robust selectors for DOM manipulation.

Compared to traditional scraping tools such as BeautifulSoup or Scrapy, Playwright is better suited for applications involving authenticated sessions and dynamically generated content @playwright.

This makes it particularly appropriate for interacting with SMI and tracking interfaces, which rely heavily on client-side rendering and session-based authentication.

=== Authentication and Session Management

Access to BAM operational systems requires authenticated sessions. The automation pipeline includes a dedicated login module that:

- Initiates a browser context;
- Submits authentication credentials;
- Stores session cookies;
- Maintains session persistence across multiple requests.

To reduce authentication overhead, session states are cached locally and reused whenever possible. When a session expires, the system automatically re-authenticates.

This mechanism ensures continuity of long-running extraction tasks without manual intervention.

=== Navigation and Form Automation

Data extraction from SMI and reporting interfaces involves navigating complex web forms with multiple filters such as:

- Date ranges;
- Destination countries;
- Service types;
- Agency identifiers.

The automation pipeline simulates user interaction by:

- Filling input fields programmatically;
- Selecting dropdown values;
- Triggering report generation buttons;
- Waiting for asynchronous page loads;
- Extracting rendered HTML tables.

This process allows structured reports to be generated programmatically despite the absence of API endpoints.

=== Robustness and Fault Tolerance

Given the instability of legacy systems under heavy queries, robustness is a critical requirement of the pipeline.

A multi-layer fault-tolerant architecture was implemented, including:

==== Retry Mechanism

Each critical operation is wrapped in a retry strategy that attempts to recover from transient failures such as:

- Network timeouts;
- Server-side errors;
- Page load failures;
- Session expiration.

If an operation fails, the system retries after a short delay, up to a predefined maximum number of attempts.

==== Session Recovery

In case of persistent failure, the pipeline:

- Terminates the current browser context;
- Re-initializes a new session;
- Re-authenticates automatically;
- Resumes execution from the last successful checkpoint.

This ensures that long extraction processes can run continuously without manual supervision.

==== Checkpointing Strategy

Progress is stored incrementally to avoid data loss. Each successfully extracted batch is saved locally, allowing the system to resume exactly where it stopped in case of interruption.

=== Idempotent Extraction Design

To ensure data consistency, the extraction process is designed to be idempotent.

Before processing a given data chunk, the system:

- Checks whether the corresponding data already exists locally;
- Skips extraction if the dataset is already complete;
- Avoids duplication of previously processed records.

This is particularly important when dealing with large-scale historical datasets spanning hundreds of thousands of shipments.

=== Chunked Extraction Strategy

Due to performance limitations in SMI reporting tools, large-scale queries often fail or become unresponsive. To mitigate this issue, data extraction is performed using a chunked approach.

The timeline is divided into small intervals (typically daily), and each interval is processed independently.

This strategy ensures:

- Reduced server load;
- Lower probability of timeout errors;
- Improved stability of extraction jobs;
- Easier recovery from partial failures.

=== HTML Parsing and Data Extraction

Once web pages are successfully retrieved, the raw HTML content is parsed to extract structured information.

The extraction process includes:

- Identification of HTML table structures;
- Extraction of tabular rows and columns;
- Normalization of field names;
- Conversion into structured dataframes.

Libraries such as lxml are used to efficiently parse large HTML documents and extract relevant fields.

=== Automation Pipeline Architecture

The complete automation pipeline is illustrated below.

#figure(
  diagram(
    node-stroke: 1pt,

    node((0, 4), name: <login>)[Authentication Module],
    node((2, 4), name: <browser>)[Playwright Browser Context],

    edge(<login>, <browser>),

    node((2, 3), name: <nav>)[Navigation & Form Automation],
    edge(<browser>, <nav>),

    node((2, 2), name: <extract>)[HTML Extraction Layer],
    edge(<nav>, <extract>),

    node((2, 1), name: <parse>)[Parsing (lxml / Regex)],
    edge(<extract>, <parse>),

    node((2, 0), name: <store>)[Structured Storage (Parquet)],
    edge(<parse>, <store>),
  ),
  caption: [Playwright-based web scraping and automation pipeline]
)

This architecture highlights the sequential transformation from authenticated browser sessions to structured analytical datasets.

=== Limitations of Web Automation

Despite its effectiveness, the web automation approach presents several limitations:

- High sensitivity to changes in web interface structure;
- Increased execution time compared to direct API access;
- Dependency on browser stability;
- Potential blocking or throttling by backend systems;
- Maintenance overhead due to UI updates.

These limitations are inherent to scraping-based approaches and reinforce the need for more modern API-driven architectures in operational systems.

=== Summary

The web scraping and automation pipeline provides a robust solution for extracting structured data from legacy operational systems lacking API access. By combining Playwright-based automation, retry mechanisms, and chunked extraction strategies, the system ensures reliable data collection under unstable and constrained conditions.

This pipeline forms a critical component of the overall data engineering architecture used in this internship.