library(annotatr)
library(readr)
library(ggplot2)
library(regioneR)
library(optparse)
library(R.utils)

################################################################################
# Deal with command line options

option_list = list(
  make_option('--file', type='character', help='[Required] Tab-delimited file with genomic locations and possibly associated data.'),
  make_option('--genome', type='character', help='[Required] The shortname for the genome used, e.g. hg19, mm9, rn4.'),
  make_option('--annot_type', type='character', help='[Required] One of bismark, simple_bisulfite_bismark, macs2, simple_pulldown_macs2, sample_class, methylSig, PePr, simple_pulldown_PePr, or compare_class. Indicates what type of data is being annotated.'),
  make_option('--group1', type='character', help='[Required] A character indicating the name of group1 or NULL.'),
  make_option('--group0', type='character', help='[Required] A character indicating the name of group0 or NULL.'),
  make_option('--output_dir', type='character'),
  make_option('--output_file', type='character'),
  make_option('--projectname', type='character'),
  make_option('--filename', type='character')
  
)




opt = parse_args(OptionParser(option_list=option_list))
genome = opt$genome
annot_type = opt$annot_type
output_dir=opt$output_dir
output_file=opt$output_file
projectname=opt$projectname


file = opt$file
inputFilename= opt$filename





print("director")
print (output_dir)
print("file")
print (output_file)
print("annot_type")
print (annot_type)


dir.create(output_dir, showWarnings = FALSE)



# If the group names are not NULL, use them
if(!is.null(opt$group1)) {
	group1 = opt$group1
	chip1 = group1
}
if(!is.null(opt$group0)) {
	group0 = opt$group0
	chip2 = group0
}


# Interpret mark
# This order matters very much!
if(grepl('mc_hmc', projectname)) {
	mark = 'mc_hmc'
} else if (grepl('hmc', projectname)) {
	mark = 'hmc'
} else if (grepl('mc', projectname)) {
	mark = 'mc'
}

################################################################################
# Deal with the annot_type
if(annot_type == 'bismark') {
	# BARPLOT + NUMERICALS
	# Random for barplot

	# gunzip -c ./bisulfite/bismark/IDH2mut_2_mc_hmc_bisulfite_trimmed_bismark_bt2.bismark.cov.gz | head
	# chr21	9437517	9437517	86.241610738255	257	41
	# chr21	9437519	9437519	75.503355704698	225	73
	# chr21	9437531	9437531	58.9225589225589	175	122
	# chr21	9437533	9437533	86.5771812080537	258	40
	col_names = c('chr','start','perc_meth','coverage')
	col_types = 'ci-di-'
	stranded = FALSE
	classifier_flag = FALSE
	log10p_flag = FALSE
	resolution = 'base'
	prefix = gsub('_bt2.bismark.cov.gz','', basename(inputFilename))
	# No categories
} else if (annot_type == 'simple_bisulfite_bismark') {
	# BARPLOT + CATEGORICALS
	# Random for barplot and categoricals

	# head ./classifications/simple/IDH2mut_1_mc_hmc_bisulfite_bismark_simple_classification.bed
	# chr1	249239097	249239098	mc_hmc_high	1000	.	249239097	249239098	102,0,102
	# chr1	249239100	249239101	mc_hmc_high	1000	.	249239100	249239101	102,0,102
	# chr1	249239104	249239105	mc_hmc_high	1000	.	249239104	249239105	102,0,102
	# chr1	249239117	249239118	mc_hmc_high	1000	.	249239117	249239118	102,0,102
	col_names = c('chr','start','end','class')
	col_types = 'ciic-----'
	stranded = FALSE
	classifier_flag = TRUE
	log10p_flag = FALSE
	resolution = 'base'
	prefix = gsub('.bed','', basename(inputFilename))

	# Make the correct category ordering
	if(mark == 'mc_hmc') {
		cats_order = c('mc_hmc_high', 'mc_hmc_med', 'mc_hmc_low', 'mc_hmc_none')
	} else if (mark == 'hmc') {
		cats_order = c('hmc_high', 'hmc_med', 'hmc_low', 'hmc_none')
	} else if (mark == 'mc') {
		cats_order = c('mc_high', 'mc_med', 'mc_low', 'mc_none')
	}

	# Variables for plot_categorical usage
	x_str = 'class'
	x_desc = 'Bisulfite Simple Classification'
} else if (annot_type == 'macs2') {
	# BARPLOT + NUMERICALS
	# Random for barplot

	# head ./pulldown/macs2_peaks/IDH2mut_2_hmc_pulldown_macs2_peaks.narrowPeak
	# chr21	9909565	9910066	IDH2mut_2_hmc_pulldown_macs2_peak_1	126	.	3.04226	16.46495	12.64028	213
	# chr21	15471800	15472211	IDH2mut_2_hmc_pulldown_macs2_peak_2	146	.	7.33008	18.53385	14.66105	186
	# chr21	15855465	15855886	IDH2mut_2_hmc_pulldown_macs2_peak_3	77	.	4.05129	11.47467	7.78926	178
	# chr21	15865175	15865647	IDH2mut_2_hmc_pulldown_macs2_peak_4	322	.	6.33401	36.40632	32.21310	240
	col_names = c('chr','start','end','name','fold','pval')
	col_types = 'ciic--dd--'
	stranded = FALSE
	classifier_flag = FALSE
	log10p_flag = FALSE
	resolution = 'region'
	prefix = gsub('_peaks.narrowPeak','', basename(inputFilename))
	# No categories
} else if (annot_type == 'simple_pulldown_macs2') {
	# BARPLOT + CATEGORICALS
	# Random for barplot and categoricals

	# head ./classifications/simple/IDH2mut_1_hmc_pulldown_macs2_simple_classification.bed
	# chr21	9944160	9944341	hmc_low	1000	.	9944160	9944341	102,102,255
	# chr21	9999539	9999701	hmc_low	1000	.	9999539	9999701	102,102,255
	# chr21	10132638	10133209	hmc_low	1000	.	10132638	10133209	102,102,255
	# chr21	10135234	10135504	hmc_low	1000	.	10135234	10135504	102,102,255
	col_names = c('chr','start','end','class')
	col_types = 'ciic-----'
	stranded = FALSE
	classifier_flag = TRUE
	log10p_flag = FALSE
	resolution = 'region'
	prefix = gsub('.bed','', basename(inputFilename))

	# Make the correct category ordering
	if (mark == 'hmc') {
		cats_order = c('hmc_high', 'hmc_med', 'hmc_low')
	} else if (mark == 'mc') {
		cats_order = c('mc_high', 'mc_med', 'mc_low')
	}

	# Variables for plot_categorical usage
	x_str = 'class'
	x_desc = 'macs2 Simple Classification'
} else if (annot_type == 'sample_class') {
	# BARPLOT + CATEGORICALS
	# Random for barplot and categoricals
	# NOTE: In the hybrid case there are so many regions that the All bar could
	# serve as the backgr

	# head ./classifications/sample/NBM_1_sample_classification.bed
	# chr1	10468	10472	unclassifiable	1000	.	10468	10472	192,192,192
	# chr1	10483	10485	unclassifiable	1000	.	10483	10485	192,192,192
	# chr1	10488	10490	unclassifiable	1000	.	10488	10490	192,192,192
	# chr1	10492	10494	unclassifiable	1000	.	10492	10494	192,192,192
	col_names = c('chr','start','end','class')
	col_types = 'ciic----'
	stranded = FALSE
	classifier_flag = TRUE
	log10p_flag = FALSE
	resolution = 'region'
	prefix = gsub('.bed','', basename(inputFilename))

	# The category ordering for this annot_type is computed below, after the file
	# is read because information from the file determines hybrid or pulldown.

	# Variables for plot_categorical usage
	x_str = 'class'
	x_desc = 'Sample Classification'
} else if (annot_type == 'methylSig') {
	# BARPLOT + NUMERICALS + CATEGORICALS
	# Random for barplot and categoricals
	# NOTE: Randoms will lack the CpG bias of methylSig regions...

	# head ./bisulfite/methylsig_calls/IDH2mut_v_NBM_mc_hmc_bisulfite_DMR_methylSig_for_annotatr.txt
	# chr21	9437472	9437521	0.000228579898882106	IDH2mut	28.6754246208103	81.4241341438466	52.7487095230364
	# chr21	9437522	9437571	0.0208553163921381	NBM	22.738738618692	85.8751984050635	63.1364597863715
	col_names = c('chr','start','end','pval','DM_status','meth_diff','mu1','mu0')
	col_types = 'ciidcddd'
	stranded = FALSE
	classifier_flag = FALSE
	log10p_flag = TRUE
	resolution = 'region'
	prefix = gsub('_for_annotatr.txt','', basename(inputFilename))

	# Categories are the group1 and group0 command line parameters
	cats_order = c(group1, group0, 'noDM')

	# Variables for plot_categorical usage
	x_str = 'DM_status'
	x_desc = sprintf('Differential %s', mark)
} else if (annot_type == 'PePr') {
	# BARPLOT + NUMERICALS + CATEGORICALS
	# Random for barplot and categoricals

	# head pulldown/pepr_peaks/IDH2mut_v_NBM_hmc_pulldown_PePr_combined.bed
	# chr21	46387680	46388640	IDH2mut	2.80016862356	*	2.28100636773e-165
	# chr21	36207120	36208800	IDH2mut	3.36810346155	*	2.74839325284e-143
	# chr21	39810080	39810880	IDH2mut	4.23550374893	*	1.25690543952e-142
	# chr21	46902720	46904640	IDH2mut	5.45917702717	*	1.27951073684e-106
	col_names = c('chr','start','end','group','fold','pval')
	col_types = 'ciicd-d'
	stranded = FALSE
	classifier_flag = FALSE
	log10p_flag = TRUE
	resolution = 'region'
	prefix = gsub('_combined.bed','', basename(inputFilename))

	# Categories are the group1 and group0 command line parameters
	cats_order = c(group1, group0)

	# Variables for plot_categorical usage
	x_str = 'group'
	x_desc = sprintf('Differential %s', mark)
} else if (annot_type == 'simple_pulldown_PePr') {
	# BARPLOT + CATEGORICALS
	# Random for barplot and categoricals

	# head classifications/simple/HPVpos_v_HPVneg_hmc_pulldown_pulldown_PePr_simple_classification.bed
	# chr1	565250	565350	diff_hmc_weak	1000	.	565250	565350	102,102,255
	# chr1	565700	565800	diff_hmc_weak	1000	.	565700	565800	102,102,255
	# chr1	565900	566000	diff_hmc_weak	1000	.	565900	566000	102,102,255
	# chr1	565950	566100	diff_hmc_strong	1000	.	565950	566100	0,0,102
	# chr1	567350	567450	diff_hmc_strong	1000	.	567350	567450	0,0,102
	col_names = c('chr','start','end','class')
	col_types = 'ciic-----'
	stranded = FALSE
	classifier_flag = TRUE
	log10p_flag = FALSE
	resolution = 'region'
	prefix = gsub('.bed','', basename(inputFilename))

	# Make the correct category ordering
	if (mark == 'hmc') {
		cats_order = c(
			paste('diff', chip1, c('hmc_strong','hmc_mod','hmc_weak'), sep='_'),
			paste('diff', chip2, c('hmc_strong','hmc_mod','hmc_weak'), sep='_'))
	} else if (mark == 'mc') {
		cats_order = c(
			paste('diff', chip1, c('mc_strong','mc_mod','mc_weak'), sep='_'),
			paste('diff', chip2, c('mc_strong','mc_mod','mc_weak'), sep='_'))
	}

	# Variables for plot_categorical usage
	x_str = 'class'
	x_desc = 'PePr Simple Classification'
} else if (annot_type == 'compare_class') {
	# BARPLOT + CATEGORICALS
	# NOTE: There are so many regions that the All bar serves as the background

	# head ./classifications/comparison/IDH2mut_v_NBM_compare_classification.bed
	# chr1	0	10000	unclassifiable	1000	.	0	10000	192,192,192
	# chr1	10000	10162	no_DM	1000	.	10000	10162	0,0,0
	# chr1	10162	10185	unclassifiable	1000	.	10162	10185	192,192,192
	# chr1	10185	10276	no_DM	1000	.	10185	10276	0,0,0
	col_names = c('chr','start','end','class')
	col_types = 'ciic----'
	stranded = FALSE
	classifier_flag = TRUE
	log10p_flag = FALSE
	resolution = 'region'
	prefix = gsub('.bed','', basename(inputFilename))

	# Make the correct category ordering
	cats_order = c(
		'hyper_mc_hyper_hmc',
		'hypo_mc_hypo_hmc',
		'hyper_mc_hypo_hmc',
		'hypo_mc_hyper_hmc',
		'hyper_mc',
		'hyper_hmc',
		'hypo_mc',
		'hypo_hmc',
		'no_DM')

	# Variables for plot_categorical usage
	x_str = 'class'
	x_desc = 'Compare Classification'
} else {
	stop('annot_type is invalid. Must be one of bismark, simple_bisulfite_bismark, macs2, simple_pulldown_macs2, sample_class, methylSig, PePr, simple_pulldown_PePr, or compare_class.')
}

print("above read region")
################################################################################
# Read the data and do some filtering / transformations as necessary
regions = read_regions(
	file = file,
	genome = genome,
	stranded = stranded,
	col_names = col_names,
	col_types = col_types,
	quiet = FALSE)

# Filter out unclassifiable classification
if(classifier_flag) {
	regions = regions[regions$class != 'unclassifiable']
}

# Convert pval column to -log10(pval)
if(log10p_flag) {
	regions$pval = -log10(regions$pval)
}
print("above read resolution")
################################################################################
# Deal with random regions depending on resolution
# NOTE: Do not do random regions for methylSig at the moment, uses too much RAM
if(resolution == 'region' && annot_type != 'sample_class' && annot_type != 'compare_class' && annot_type != 'methylSig') {
	regions_rnd = randomize_regions(regions = regions, genome = genome)
} else if (resolution == 'base' && genome == 'hg19') {
	regions_rnd = NULL
} else {
	regions_rnd = NULL
}

################################################################################
# Pick annotations and order them
# Created variables: annot_cpg_order, annot_gene_order, annot_all_order
if(genome %in% c('hg19','hg38','mm9','mm10')) {
	if(genome == 'hg19') {
		annot_cpg_order = paste(genome, c(
			'cpg_islands',
			'cpg_shores',
			'cpg_shelves',
			'cpg_inter'), sep='_')
		annot_gene_order = paste(genome, c(
			'enhancers_fantom',
			'knownGenes_1to5kb',
			'knownGenes_promoters',
			'knownGenes_5UTRs',
			'knownGenes_exons',
			'knownGenes_introns',
			'knownGenes_3UTRs',
			'knownGenes_intergenic'), sep='_')
		annot_all_order = c(
			annot_cpg_order,
			annot_gene_order)
	} else {
		annot_cpg_order = paste(genome, c(
			'cpg_islands',
			'cpg_shores',
			'cpg_shelves',
			'cpg_inter'), sep='_')
		annot_gene_order = paste(genome, c(
			'knownGenes_1to5kb',
			'knownGenes_promoters',
			'knownGenes_5UTRs',
			'knownGenes_exons',
			'knownGenes_introns',
			'knownGenes_3UTRs',
			'knownGenes_intergenic'), sep='_')
		annot_all_order = c(
			annot_cpg_order,
			annot_gene_order)
	}
} else {
	# TODO: Add support for insertion of custom annotation path via command line
	stop('Only hg19, hg38, mm9, and mm10 annotations are supported for this part of mint at the moment.')
}

################################################################################
# Order categories for sample classification case (others are above)
# Must have read in the file to deduce the classes
# Created variables: cats_order
if (annot_type == 'sample_class') {
	cats = unique(regions$class)
	if('mc_or_hmc' %in% cats) {
		# hybrid sample
		cats_order = c(
			'mc',
			'mc_low',
			'hmc',
			'mc_or_hmc',
			'mc_or_hmc_low',
			'no_meth')
	} else if ('mc_and_hmc' %in% cats) {
		# pulldown sample
		cats_order = c(
			'mc_and_hmc',
			'mc',
			'hmc',
			'no_meth')
	}
}

################################################################################
# For strict macs2 and PePr output, create dplyr::tbl_df on which to create
# overall distributions of fold change
if(annot_type == 'macs2') {
	regions_tbl = dplyr::tbl_df(data.frame(
		'chr' = seqnames(regions),
		'start' = start(regions),
		'end' = end(regions),
		'fold' = mcols(regions)$fold,
		'pval' = mcols(regions)$pval,
		stringsAsFactors=F))
} else if (annot_type == 'PePr') {
	regions_tbl = dplyr::tbl_df(data.frame(
		'chr' = seqnames(regions),
		'start' = start(regions),
		'end' = end(regions),
		'group' = mcols(regions)$group,
		'fold' = mcols(regions)$fold,
		'pval' = mcols(regions)$pval,
		stringsAsFactors=F))
} else {
	regions_tbl = NULL
}

################################################################################
# Do the annotation of the regions

annotated_regions = annotate_regions(regions = regions, annotations = annot_all_order)

# If regions_rnd has GRanges class, then annotate, otherwise you read in the CpG annotation table
if('GRanges' %in% is(regions_rnd)) {
	annotated_regions_rnd = annotate_regions(regions = regions_rnd, annotations = annot_all_order)
} else {
	annotated_regions_rnd = NULL
}
print(prefix)
print("above content")
content=paste('<HEAD><TITLE>Annotatr Results</TITLE></HEAD>',
             '<body><style>body {background-color: #dcdcdc;font-family: Arial, Helvetica, sans-serif;font-size: 11px;color: #444444;clear: both;}',
             '#mainPanel {width: 900px;	background-color: #fff;	border: thin;border-style: solid;border-color: #bebebe;}','h1,h3 {color: #0F226E;}',
             '</style>',
             '<CENTER><div id="mainPanel"><H1>Annotatr Results</H1>')
             
print("below content")
################################################################################
# Summarize annotations
count_annots = summarize_annotations(annotated_regions = annotated_regions, annotated_random = annotated_regions_rnd)

# Write it
readr::write_tsv(x = count_annots, path = sprintf('%s/%s_annotation_counts.txt',output_dir, prefix))
filename=sprintf('%s_annotation_counts.txt',prefix)
print("tsv file content")
content=paste(content,'<h3>',filename,'</h3>','<a href="',sprintf('%s_annotation_counts.txt',prefix),'">Annotation Counts</a>')
print("tsv file content2")

################################################################################
# Plots

#############################################################
# Barplot of # of regions per annotation
# NOTE: This is the same for all the types
if(!is.null(annotated_regions_rnd)) {
	# Use randomized regions
	file_png = sprintf('%s/%s_counts.png',output_dir, prefix)
	plot_counts = plot_annotation(
		annotated_regions = annotated_regions,
		annotated_random = annotated_regions_rnd,
		annotation_order = annot_all_order,
		plot_title = sprintf('%s regions per annotation', prefix),
		x_label = 'Annotations',
		y_label = '# Regions')
	ggsave(filename = file_png, plot = plot_counts, width = 8, height = 6)
} else {
	# Use CpG annotations as a post annotatr add on
	file_png = sprintf('%s/%s_counts.png',output_dir, prefix)
	plot_counts = plot_annotation(
		annotated_regions = annotated_regions,
		annotation_order = annot_all_order,
		plot_title = sprintf('%s regions per annotation', prefix),
		x_label = 'Annotations',
		y_label = '# Regions')
	ggsave(filename = file_png, plot = plot_counts, width = 8, height = 6)
}
print("counts png content")
content=paste(content,'<h3>',sprintf('%s regions per annotation', prefix),'</h3>','<img src= "',sprintf('%s_counts.png',prefix),'" alt="box plot" style="width:50%;height:50%;">' )
print("counts png content2")

#############################################################
# plot_numerical specific to bismark
if(annot_type == 'bismark') {
	##############################
	# CpG read coverage (limited to 500)
	# NOTE: Will receive a warning like:
	# Warning messages:
	# 1: Removed 578 rows containing non-finite values (stat_bin).
	# 2: Removed 6936 rows containing non-finite values (stat_bin).
	# When there are coverages exceeding the x limits
	file_png = sprintf('%s/%s_coverage.png',output_dir, prefix)
	plot_coverage = plot_numerical(
		tbl = annotated_regions,
		x = 'coverage',
		facet = 'annot_type',
		facet_order = annot_all_order,
		bin_width = 10,
		plot_title = sprintf('%s coverage over annotations', prefix),
		x_label = 'Coverage')
	plot_coverage = plot_coverage + xlim(0,500)
	ggsave(filename = file_png, plot = plot_coverage, width = 8, height = 8)
 content=paste(content,'<h3>', sprintf('%s coverage over annotations', prefix),'</h3>','<img src= "',sprintf('%s_coverage.png',prefix),'" alt="box plot" style="width:50%;height:50%;">' )
	##############################
	# Percent methylation over annotations
	file_png = sprintf('%s/%s_percmeth.png',output_dir, prefix)
	plot_percmeth = plot_numerical(
		tbl = annotated_regions,
		x = 'perc_meth',
		facet = 'annot_type',
		facet_order = annot_all_order,
		bin_width = 5,
		plot_title = sprintf('%s perc. meth. over annotations', prefix),
		x_label = 'Percent Methylation')
	ggsave(filename = file_png, plot = plot_percmeth, width = 8, height = 8)
  content=paste(content,'<h3>',sprintf('%s perc. meth. over annotations', prefix),'</h3>','<img src= "',sprintf('%s_percmeth.png',prefix),'" alt="box plot" style="width:50%;height:50%;">' )


}

#############################################################
# plot_numerical specific to methylSig
if(annot_type == 'methylSig') {
	##############################
	# Methylation difference over annotations
	file_png = sprintf('%s/%s_methdiff.png',output_dir, prefix)
	plot_methdiff = plot_numerical(
		tbl = subset(annotated_regions, annotated_regions$DM_status != 'noDM'),
		x = 'meth_diff',
		facet = 'annot_type',
		facet_order = annot_all_order,
		bin_width = 5,
		plot_title = sprintf('%s meth. diff. over annotations', prefix),
		x_label = sprintf('Methylation Difference (%s - %s)', group1, group0))
	ggplot2::ggsave(filename = file_png, plot = plot_methdiff, width = 8, height = 8)
       content=paste(content,'<h3>Methylation difference over annotations</h3>','<img src= "',sprintf('%s_methdiff.png',prefix),'" alt="box plot" style="width:50%;height:50%;">' )

	##############################
	# Volcano plots over annotations
	file_png = sprintf('%s/%s_volcano.png',output_dir, prefix)
	plot_volcano = plot_numerical(
		tbl = subset(annotated_regions, annotated_regions$DM_status != 'noDM'),
		x = 'meth_diff',
		y = 'pval',
		facet = 'annot_type',
		facet_order = annot_all_order,
		plot_title = sprintf('%s meth. diff. vs -log10(pval)', prefix),
		x_label = sprintf('Methylation Difference (%s - %s)', group1, group0),
		y_label = '-log10(pval)')
	ggplot2::ggsave(filename = file_png, plot = plot_volcano, width = 8, height = 8)
       content=paste(content,'<h3> Volcano plots over annotations</h3>','<img src= "',sprintf('%s_volcano.png',prefix),'" alt="box plot" style="width:50%;height:50%;">' )
        
}

#############################################################
# Overall fold-change, peak width, and volcano plots for macs2 & PePr

if(!is.null(regions_tbl)) {
	##############################
	# Peak widths
        print("inside regios_tbl")
	widths = data.frame(
		region = 1:length(regions),
		width = end(regions) - start(regions), stringsAsFactors=F)
	print (1)
	file_png = sprintf('%s/%s_peak_widths.png',output_dir, prefix)
	plot_region_widths = ggplot(data = widths, aes(x = width, y=..density..)) +
		scale_x_log10() + geom_histogram(stat = 'bin', fill = NA, color='gray', bins=30) +
		theme_bw() +
		xlab('Peak Widths (log10 scale)') +
		ggtitle(sprintf('%s peak widths', prefix))
	ggsave(filename = file_png, plot = plot_region_widths, width = 6, height = 6)
        content=paste(content,'<h3> Peak Width</h3>','<img src= "',sprintf('%s_peak_widths.png', prefix),'" alt="box plot" style="width:50%;height:50%;">' )

	##############################
	# Fold changes
        print (2)
	file_png = sprintf('%s/%s_foldchg_overall.png',output_dir, prefix)
	plot_foldchg = ggplot(data = regions_tbl, aes(x = fold, y=..density..)) +
		geom_histogram(stat = 'bin', fill = NA, color='gray', bins=30) +
		theme_bw() +
		xlab('Fold Change') +
		ggtitle(sprintf('%s Overall Fold Change', prefix))
	ggsave(filename = file_png, plot = plot_foldchg, width = 6, height = 6)
       content=paste(content,'<h3> Fold Change</h3>','<img src= "',sprintf('%s_foldchg_overall.png', prefix),'" alt="box plot" style="width:50%;height:50%;">' )   

	##############################
	# Volcano plots
        print (3)
	file_png = sprintf('%s/%s_volcano_overall.png',output_dir, prefix)
	plot_volcano = ggplot(data = regions_tbl, aes(x = fold, y = pval)) +
		geom_point(alpha = 1/8, size = 1) +
		theme_bw() +
		xlab('Fold Change') +
		ylab('-log10(pval)')
		ggtitle(sprintf('%s Overall Fold Change', prefix))
	ggsave(filename = file_png, plot = plot_volcano, width = 6, height = 6)
       content=paste(content,'<h3> Volcano overall</h3>','<img src= "',sprintf('%s_volcano_overall.png', prefix),'" alt="box plot" style="width:50%;height:50%;">' )  
}

#############################################################
# plot_numerical specific to macs2
if(annot_type == 'macs2') {
	##############################
	# Fold change over annotations
	file_png = sprintf('%s/%s_foldchg_annots.png', output_dir,prefix)
	plot_foldchg = plot_numerical(
		tbl = annotated_regions,
		x = 'fold',
		facet = 'annot_type',
		facet_order = annot_all_order,
		bin_width = 5,
		plot_title = sprintf('%s fold change over annotations', prefix),
		x_label = 'Fold Change')
	ggsave(filename = file_png, plot = plot_foldchg, width = 8, height = 8)
        content=paste(content,'<h3> Fold change over annotations</h3>','<img src= "',sprintf('%s_foldchg_annots.png',prefix),'" alt="box plot" style="width:50%;height:50%;">' )  

	##############################
	# Volcano plots over annotations
	file_png = sprintf('%s/%s_volcano_annots.png',output_dir, prefix)
	plot_volcano = plot_numerical(
		tbl = annotated_regions,
		x = 'fold',
		y = 'pval',
		facet = 'annot_type',
		facet_order = annot_all_order,
		plot_title = sprintf('%s fold change vs -log10(pval)', prefix),
		x_label = 'Fold change IP / input',
		y_label = '-log10(pval)')
	ggsave(filename = file_png, plot = plot_volcano, width = 8, height = 8)
         content=paste(content,'<h3> Volcano plots over annotations</h3>','<img src= "',sprintf('%s_volcano_annots.png',prefix),'" alt="box plot" style="width:50%;height:50%;">' )  
}

#############################################################
# plot_numerical specific to PePr
if(annot_type == 'PePr') {
	##############################
	# Fold change with facet over group (chip1/chip2)
	file_png = sprintf('%s/%s_foldchg_groups.png',output_dir, prefix)
        print(cats_order)
	plot_foldchg = plot_numerical(
		tbl = regions_tbl,
		x = 'fold',
		facet = 'group',
		facet_order = cats_order,
		bin_width = 5,
		plot_title = sprintf('%s fold change over annotations', prefix),
		x_label = 'Fold Change')
	ggsave(filename = file_png, plot = plot_foldchg, width = 12, height = 6)
        content=paste(content,'<h3> fold change over annotations</h3>','<img src= "',sprintf('%s_foldchg_groups.png', prefix),'" alt="box plot" style="width:50%;height:50%;">' )  
	print(4)
	##############################
	# Volcano plots with facet over group (chip1/chip2)
	file_png = sprintf('%s/%s_volcano_groups.png',output_dir, prefix)
	plot_volcano = plot_numerical(
		tbl = regions_tbl,
		x = 'fold',
		y = 'pval',
		facet = 'group',
		facet_order = cats_order,
		plot_title = sprintf('%s fold change vs -log10(pval)', prefix),
		x_label = 'Fold change',
		y_label = '-log10(pval)')
	ggsave(filename = file_png, plot = plot_volcano, width = 12, height = 6)
	content=paste(content,'<h3> Volcano plots with facet over group (chip1/chip2) Fold change vs -log10(pval)</h3>','<img src= "',sprintf('%s_volcano_groups.png', prefix),'" alt="box plot" style="width:50%;height:50%;">' )  
        print(chip1)
	##############################
	# Fold change in chip1 with facet over annots
	file_png = sprintf('%s/%s_foldchg_%s_annots.png',output_dir, prefix, chip1)
	plot_foldchg = plot_numerical(
		tbl = subset(annotated_regions, group == chip1),
		x = 'fold',
		facet = 'annot_type',
		facet_order = annot_all_order,
		bin_width = 5,
		plot_title = sprintf('%s %s fold change over annotations', prefix, chip1),
		x_label = sprintf('%s fold change', chip1))
	ggsave(filename = file_png, plot = plot_foldchg, width = 8, height = 8)
       content=paste(content,'<h3> Fold change in chip1 with facet over annots </h3>','<img src= "',sprintf('%s_foldchg_%s_annots.png', prefix, chip1),'" alt="box plot" style="width:50%;height:50%;">' )  
	print(6)
	##############################
	# Volcano in chip1 with facet over annots
	file_png = sprintf('%s/%s_volcano_%s_annots.png',output_dir, prefix, chip1)
	plot_volcano = plot_numerical(
		tbl = subset(annotated_regions, group == chip1),
		x = 'fold',
		y = 'pval',
		facet = 'annot_type',
		facet_order = annot_all_order,
		plot_title = sprintf('%s %s fold change vs -log10(pval)', prefix, chip1),
		x_label = sprintf('%s fold change', chip1),
		y_label = '-log10(pval)')
	ggsave(filename = file_png, plot = plot_volcano, width = 8, height = 8)
        content=paste(content,'<h3> Volcano in chip1 with facet over annots </h3>','<img src= "',sprintf('%s_volcano_%s_annots.png',prefix, chip1),'" alt="box plot" style="width:50%;height:50%;">' )  
	print(7)
	##############################
	# Fold change in chip2 with facet over annots
	file_png = sprintf('%s/%s_foldchg_%s_annots.png',output_dir, prefix, chip2)
	plot_foldchg = plot_numerical(
		tbl = subset(annotated_regions, group == chip2),
		x = 'fold',
		facet = 'annot_type',
		facet_order = annot_all_order,
		bin_width = 5,
		plot_title = sprintf('%s %s fold change over annotations', prefix, chip2),
		x_label = sprintf('%s fold change', chip2))
	ggsave(filename = file_png, plot = plot_foldchg, width = 8, height = 8)
	content=paste(content,'<h3> Fold change in chip2 with facet over annots </h3>','<img src= "',sprintf('%s_foldchg_%s_annots.png',prefix, chip2),'" alt="box plot" style="width:50%;height:50%;">' )  
	print(8)
	##############################
	# Volcano in chip2 with facet over annots
	file_png = sprintf('%s/%s_volcano_%s_annots.png',output_dir, prefix, chip2)
	plot_volcano = plot_numerical(
		tbl = subset(annotated_regions, group == chip2),
		x = 'fold',
		y = 'pval',
		facet = 'annot_type',
		facet_order = annot_all_order,
		plot_title = sprintf('%s %s fold change vs -log10(pval)', prefix, chip2),
		x_label = sprintf('%s fold change', chip2),
		y_label = '-log10(pval)')
	ggsave(filename = file_png, plot = plot_volcano, width = 8, height = 8)
        content=paste(content,'<h3> Volcano in chip2 with facet over annots</h3>','<img src= "',sprintf('%s_volcano_%s_annots.png', prefix, chip2),'" alt="box plot" style="width:50%;height:50%;">' )  
        print(9)
}

#############################################################
# plot_categorical specific to PePr, methylSig, simple, sample, and compare classifications
# Use x_str and x_desc variables determined near the top of this file when determining annot_type
if(annot_type != 'bismark' && annot_type != 'macs2') {
	##############################
	# Regions split by category and stacked by CpG annotations (count)
	file_png = sprintf('%s/%s_cat_count_cpgs.png',output_dir, prefix)
	plot_cat_count_cpgs = plot_categorical(
		annotated_regions = annotated_regions,
		annotated_random = annotated_regions_rnd,
		x=x_str, fill='annot_type',
		x_order = cats_order, fill_order = annot_cpg_order, position='stack',
		plot_title = prefix,
		legend_title = 'CpG annots.',
		x_label = x_desc,
		y_label = 'Count')
	ggsave(filename = file_png, plot = plot_cat_count_cpgs, width = 8, height = 8)
        content=paste(content,'<h3>',sprintf('%s_cat_count_cpgs.png', prefix),'</h3>','<img src= "',sprintf('%s_cat_count_cpgs.png',prefix),'" alt="box plot" style="width:50%;height:50%;">' )

	##############################
	# Regions split by category and stacked by knownGene annotations (count)
	file_png = sprintf('%s/%s_cat_count_genes.png',output_dir, prefix)
	plot_cat_count_genes = plot_categorical(
		annotated_regions = annotated_regions,
		annotated_random = annotated_regions_rnd,
		x=x_str, fill='annot_type',
		x_order = cats_order, fill_order = annot_gene_order, position='stack',
		plot_title = prefix,
		legend_title = 'knownGene annots.',
		x_label = x_desc,
		y_label = 'Count')
	ggsave(filename = file_png, plot = plot_cat_count_genes, width = 8, height = 8)
        content=paste(content,'<h3>',sprintf('%s_cat_count_genes.png', prefix),'</h3>','<img src= "',sprintf('%s_cat_count_genes.png', prefix),'" alt="box plot" style="width:50%;height:50%;">' )

	##############################
	# Regions split by category and filled by CpG annotations (prop)
	file_png = sprintf('%s/%s_cat_prop_cpgs.png',output_dir, prefix)
	plot_cat_prop_cpgs = plot_categorical(
		annotated_regions = annotated_regions,
		annotated_random = annotated_regions_rnd,
		x=x_str, fill='annot_type',
		x_order = cats_order, fill_order = annot_cpg_order, position='fill',
		plot_title = prefix,
		legend_title = 'CpG annots.',
		x_label = x_desc,
		y_label = 'Proportion')
	ggsave(filename = file_png, plot = plot_cat_prop_cpgs, width = 8, height = 8)
        content=paste(content,'<h3>',sprintf('%s_cat_prop_cpgs.png',prefix),'</h3>','<img src= "',sprintf('%s_cat_prop_cpgs.png',prefix),'" alt="box plot" style="width:50%;height:50%;">' )

	##############################
	# Regions split by category and filled by knownGene annotations (prop)
	file_png = sprintf('%s/%s_cat_prop_genes.png',output_dir, prefix)
	plot_cat_prop_genes = plot_categorical(
		annotated_regions = annotated_regions,
		annotated_random = annotated_regions_rnd,
		x=x_str, fill='annot_type',
		x_order = cats_order, fill_order = annot_gene_order, position='fill',
		plot_title = prefix,
		legend_title = 'knownGene annots.',
		x_label = x_desc,
		y_label = 'Proportion')
	ggsave(filename = file_png, plot = plot_cat_prop_genes, width = 8, height = 8)
        content=paste(content,'<h3>',sprintf('%s_cat_prop_genes.png', prefix),'</h3>','<img src= "',sprintf('%s_cat_prop_genes.png',prefix),'" alt="box plot" style="width:50%;height:50%;">' )
}

################################################################################
# Record .RData object of the sessionannotation_counts
save.image(file = sprintf('%s/%s_annotatr_analysis.RData',output_dir, prefix))



print("done running R ")

write(content, file = output_file,
      append = FALSE, sep = " ")

