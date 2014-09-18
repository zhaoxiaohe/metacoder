---
title: "Workflow Example"
author: "Zachary Foster"
date: "2014-09-12"
output: rmarkdown::html_vignette
vignette: >
%\VignetteIndexEntry{Vignette Title}
%\VignetteEngine{knitr::rmarkdown}
%\usepackage[utf8]{inputenc}
---


```r
# Download example sequences -------------------------------
search_for <- c("Albuginales", "Lagenidiales",
                "Leptomitales", "Peronosporales",
                "Saprolegniales", "Pythiales",
                "ascomycota", "basidiomycota")

seq <- download_gb_taxon(taxon = search_for,
                         key = c("@18S@", "@28S@"),
                         type = "RRNA",
                         seq_length=c(2000, 100000),
                         max_count = 300, 
                         separate = TRUE)

# Download and format taxonomy information -----------------
raw_taxonomy <- taxize::classification(seq$taxon,
                                       db="col")

seq <- seq[!is.na(raw_taxonomy), ]
taxonomy <- raw_taxonomy[!is.na(raw_taxonomy)]
taxonomy <- format_taxize(taxonomy)

# Simulate PCR to evaluate primers -------------------------
pcr <- primersearch(sequence = seq$sequence,
                    forward = "TCCGTAGGTGAACCTGCGG",
                    reverse = "CGCATTACGTATCGCAGTTCGCAG",
                    seq_name = taxonomy,
                    pair_name = "ITS1__and__OOM-LO5.8S47B",
                    mismatch = 10)

# Calculate taxon-specific PCR success ---------------------
nodes <- get_nodes_from_leafs(taxonomy)
seq_counts <- count_nodes_in_leafs(taxonomy, nodes)
pcr_counts <- count_nodes_in_leafs(pcr$name, nodes)
pcr_proportions <- pcr_counts / seq_counts

# Plot results ---------------------------------------------
plot_value_tree(nodes, pcr_proportions,
                labels = get_tips(nodes),
                save = "~/test.png", 
                scaling = seq_counts * 3)
```




```r
search_for <- c("Albuginales", "Lagenidiales", "Leptomitales", "Peronosporales", "Saprolegniales", "Pythiales", "ascomycota", "basidiomycota", "Bacillariophyta")

seq <- download_gb_taxon(taxon = search_for,
                         standardize=FALSE,
                         key = c("@18S@", "@28S@"),
                         type = "RRNA",
                         seq_length=c(2000, 100000),
                         max_count = 300, 
                         separate = TRUE)


raw_taxonomy <- taxize::classification(seq$taxon, db="col", verbose=FALSE, ask=FALSE)
seq <- seq[!is.na(raw_taxonomy), ]
taxonomy <- raw_taxonomy[!is.na(raw_taxonomy)]
taxonomy <- format_taxize(taxonomy)



pcr <- primersearch(sequence = seq$sequence,
                    forward = "TCCGTAGGTGAACCTGCGG",
                    reverse = "CGCATTACGTATCGCAGTTCGCAG",
                    seq_name = taxonomy,
                    pair_name = "ITS1__and__OOM-LO5.8S47B",
                    mismatch = 10)

nodes <- get_nodes_from_leafs(taxonomy)
seq_counts <- count_nodes_in_leafs(taxonomy, nodes)
pcr_counts <- count_nodes_in_leafs(pcr$name, nodes)
pcr_proportions <- pcr_counts / seq_counts

plot_value_tree(nodes, pcr_proportions,
                labels = get_tips(nodes),
                save = "~/test.png", 
                scaling = seq_counts * 3)


dist_matrix <- pairwise_distance(sequences = pcr$amplicon,
                                 seq_name = pcr$name)


stats <- calculate_barcode_statistics(dist_matrix,
                                      level_to_analyze="Species",
                                      saved_output_path = "~/test",
                                      save_statistics = TRUE,
                                      save_raw_data = TRUE,
                                      save_plots = TRUE,
                                      distance_bin_width = 0.001,
                                      threshold_resolution = 0.001)


#Plot distance distribution tree graph
png(file = distance_tree_plot_path, bg = "transparent", width = 10000, height = 10000)
plot_image_tree(stats$taxon, stats$distance_graph,
                scaling= stats$count, 
                exclude=taxa_to_exclude)
dev.off()

#Plot optimal threshold tree graph
png(file = threshold_tree_plot_path, bg = "transparent", width = 10000, height = 10000)
plot_image_tree(stats$taxon, stats$threshold_graph,
                scaling= stats$count, 
                exclude=taxa_to_exclude)
dev.off()
```