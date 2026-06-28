#import "@preview/mmdr:0.2.2": mermaid


The shipment tracking system provides detailed operational information describing the progression of parcels through the postal network. Unlike the datasets discussed previously, this information is not exposed through downloadable reports or programmatic interfaces. Instead, it is only accessible through an interactive webpage where users manually enter a shipment identifier and obtain the corresponding tracking history as an HTML table.

As explained in @appendix_data_smi_envoisbyproduitintern, shipment identifiers were extracted from the `smi_envoisbyproduitintern` dataset and used as inputs for an automated collection procedure. A Playwright-based scraper was developed to query the tracking webpage for each identifier individually and download the resulting HTML page.

@fig-tracking-pipeline illustrates the overall acquisition and transformation workflow.

#figure(
  mermaid(
    "
flowchart TD

A[smi_envoisbyproduitintern]

B[Extract codeenvoi_]

C[Playwright automation]

D[Tracking webpage]

E[Raw HTML archive]

F[lxml parsing]

G[fields.parquet]

H[operations.parquet]

I[delivery.parquet]

J[services.parquet]

A --> B
B --> C
C --> D
D --> E
E --> F

F --> G
F --> H
F --> I
F --> J
",
  ),
  caption: [Tracking data acquisition pipeline],
)<fig-tracking-pipeline>

@fig-tracking-pipeline highlights that the forecasting datasets were not directly available from the operational information systems. Instead, they had to be reconstructed through a dedicated extraction and transformation workflow specifically developed during the internship.

To preserve a complete source of truth, the raw HTML responses associated with approximately 234,000 shipments were archived locally before any processing step was performed. This archive initially occupied approximately 10.2 GB of storage.

An ETL procedure based on the `lxml` library was subsequently implemented to parse the downloaded HTML files and extract structured information. The extracted data were organized into four distinct parquet datasets:

- `fields.parquet`, containing shipment-level attributes and static information;
- `operations.parquet`, describing the sequence of operational events experienced by each shipment;
- `delivery.parquet`, containing delivery-related information and financial attributes;
- `services.parquet`, describing optional services associated with shipments.

The use of the Apache Parquet format considerably reduced storage requirements thanks to dictionary encoding and Snappy compression. The initial archive size of approximately 10.2 GB was reduced to roughly 35 MB, corresponding to a reduction of more than 99.6%.

Besides improving storage efficiency, the conversion to parquet substantially accelerated subsequent analytical operations, particularly filtering, aggregation, and exploratory queries performed using Polars.

The resulting parquet datasets formed the analytical foundation used throughout the remainder of this internship.
