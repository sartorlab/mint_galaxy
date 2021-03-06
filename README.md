# mint_galaxy
Galaxy pipeline for the Mint 

## Contents

* [Overview](#overview)
* [Galaxy Installation](#installation)
* [Customize Galaxy Instance](#customize_galaxy)
	* [Change galaxy.ini file](#galaxy_ini)
		* [Add admin](#add_admin)
		* [Change config file extensions](#change_config_file_extensions) 
* [Add tools](#add_tools)		
	* [Custom tools](#custom_tools)
	* [Tool shed tools](#tool_shed)	
* [Import workflow](#import_workflow)	
	

## Installation

Download the galaxy local  instance from the using below command. 
```
git clone -b release_16.10 https://github.com/galaxyproject/galaxy.git
```
Refer to https://galaxyproject.org/admin/get-galaxy/  link for additional questions. 
Output for the above command should look like below:
![Galaxy Command Line](https://github.com/psnehal/GalaxyScreenshots/blob/master/galaxyscreenshot0.png)

Once the galaxy is downloaded you can check if it its running correctly using sh run.sh command
![Galaxy Command Line](https://github.com/psnehal/GalaxyScreenshots/blob/master/galaxyscreenshot2.png)


Galaxy instance main page will look like below when you go to http://127.0.0.1:8080 address: 

![Galaxy Command Line](https://github.com/psnehal/GalaxyScreenshots/blob/master/galaxyscreenshot3.png)


[Top](#contents)

## customize_galaxy
Once galaxy is installed properly on the server, you will need to make some changes in the galaxy instance in order to add custom tools: 
### Galaxy_ini
#### Add_admin
 In order to add tools and manage galaxy, you will have to become admin of local instance. 
 For that create galaxy user by registering at galaxy web page. Give the user admin privileges like this: 
 You add the Galaxy login ( email ) to the Galaxy configuration file (config/galaxy.ini). 
 If the file does not exist you can copy it from the provided sample (config/galaxy.ini.sample). 
 
 ```
 admin_users = user1@example.com,user2@example.com
```
Note that you have to restart Galaxy after modifying the configuration for changes to take effect. Sample galaxy.ini file is added into github config folder.


#### Change_config_file_extensions
Copy tool_conf.xml.main into tool_conf.xml, shed_tool_conf.xml.sample into shed_tool_conf.xml file ,tool_data_table_conf.xml.sample into tool_data_table_conf.xml and tool_sheds_conf.xml.sample into tool_sheds_conf.xml.sample. 
and then change below parameters in the galaxy.ini file: 
```
tool_config_file = config/tool_conf.xml, config/shed_tool_conf.xml
retry_metadata_internally = False
job_working_directory = database/job_working_directory
tool_data_table_config_path = config/tool_data_table_conf.xml
tool_sheds_config_file = config/tool_sheds_conf.xml
```



[Top](#contents)
## Add_tools
### Custom_tools
  
To add custom tools into galaxy, copy and paste below text into your tool_conf.xml file
```
<label id="mintools" text="Mint Tools" />  
<section id="mintprep" name="Mint-Preprocessing">
</section>

<section id="pulldown_alignment" name="Mint-Pulldown Align">      
<tool file="pulldown_alignment/process_pulldown_single.xml" /> 
<tool file="pulldown_alignment/pullalimergeBed.xml" /> 
<tool file="pulldown_alignment/pullaligenomeCoverageBed.xml" /> 
</section>

<section id="pulldown_compare" name="Mint-Pulldown Compare">
<tool file=" pulldown_compare /pepr.xml" />
<tool file=" pulldown_compare /pepr_peakCalling.xml" />
<tool file=" pulldown_compare /ForMacsFile.xml" />
<tool file=" pulldown_compare /pepr_combine.xml" />
<tool file="pullc/merged_signal.xml" />
</section>

<section id="pulldown_sample" name="Mint-Pulldown Sample">
<tool file="pulldown_sample/ForMacsFile.xml" />
</section>

<section id="bisalign" name="Mint-Bisulfite Align">  
</section>

<section id="bissam" name="Mint-Bisulfite Sample">  
 <tool file="bisulfilte_sample/bismarkToBedGraph.xml" />
 <tool file="bisulfilte_sample/bismarkToAnnotatr.xml" />
 </section>

  <section id="biscomp" name="Mint-Bisulfite Compare">
  <tool file=" bisulfilte_compare/methylSigReadData.xml" />
  <tool file=" bisulfilte_compare /methylSig_to_annotatr.xml" /> 
  <tool file=" bisulfilte_compare /annotatr_bis_alignR.xml" />
  <tool file=" bisulfilte_compare /to_bGphToBg.xml" />
  </section>

  <section id="minclass" name="Mint-Classification">
  </section>

  <section id="sample_classification" name="Mint-Sample-Classification">
  <tool file="sample_classification/bisulfite_samclass.xml" />
   <tool file="sample_classification/sam_class_bedtools.xml" />
  <tool file="sample_classification/classification_bed.xml" />  
  </section>
  
  <section id="compare_classification" name="Mint-Compare-Classification">
  <tool file="compare_classification/pulldown_comclass.xml" />
  <tool file="compare_classification/bisulfite_comclass.xml" />
  <tool file="compare_classification/classify_compare.xml" />  
  </section>
  

   <section id="mnuti" name="Mint-Utilities">
   <tool file="filters/wig_to_bigwig.xml" />
   <tool file="filters/bed_to_bigbed.xml" />
   <tool file=" mint_utilities /classify_simple.xml" />  
   <tool file=" mint_utilities /annotatr_claasification_bismark.xml" />
   <tool file=" mint_utilities /claasify_to_annotatr.xml" /> 
  </section>
  <section id="btools" name="Bedtools"> 
  </section>
  <section id="stool" name="Samtools">
  </section>

```

and then copy all the folders from tools folder.
For custom tools, back-end installation of tools is required. Refer to the install_tools.sh file on github for manual installation.
```
  bash install_deps.sh
 ```
  
Also for some of the tools, user needs to change the path of the R scripts as those are coded according to admin server.

* Add the location of genome file in bowtie tool. Go to pulldown align folder and edit  multi_output_configured_4.sh file

* Go to Mint utilities folder and edit annotatr_claasification_bismark.xml and classify_simple.xml file and  add the path for annotatr_classification_bismark.R  and classify_simple. R file respectively.

* GO to bisulfite_compare folder and edit the file annotatr_bis_alignR.xml. Add the path for annotatr_bis_alignR



	
Below is the list of the custom tools needed for mint pipeline:
```
custom installation of these tools is required:

    bedops v2.4.14 
    cutadapt v1.10
    multiqc v0.6.0
    bowtie2 v2.2.4
    PePr v1.1.11
    R >= v3.2.5
        annotatr v0.7.5
        devtools
        dplyr
        ggplot2
        methylSig v0.4.3
        optparse
        readr
        regioneR
```


### Tool_shed 

Once you add admin email id into galaxy.ini file , you should be able to see admin tab in galaxy

![Galaxy Command Line](https://github.com/psnehal/GalaxyScreenshots/blob/master/galaxyscreenshot4.png)
Click on the search tool shed option and enter the name of tool you want to install .
Below is list of the tools required to install from shed_tools
```

| Tools        | Source               | Version   |Section To install   |
| -------------|:--------------------:| -----:  |    -----:             |
| bedtools     | iuc 8e6b7c3597a8     | v.2.25.0 | Bedtools		|
| bismark      | iuc c9bd782f5342     | v0.16.1  | Mint-Bisulfite Align |
| FastQC       | devteam 3fdc1a74d866 | v0.11.4  | Mint-Preprocessing   |
| MACS2        | iuc 6d4babad010f     | v2.1.0   | Mint-Pulldown Sample |
| samtools_sort| devteam a430da4f04cd | v1.2     | Samtools             |
| sort_to_bam  | devteam 881e16ad05c6 | v1.2     | Samtools             |
| trim_galore  | bgruening f1e71aeaa923| v0.4.2 |  Mint-Preprocessing   |
| fastq groomer| devteam e4d28c94242d | v1.0.4   | Mint-Preprocessing   |



```
Version number are important while installing tools If you want to use already created workflow.
NOTE: Sometimes tool shed tools are failed to install at the backend(e.g. multiqc). You can refer to install.sh script in repository to install tools.This way you will submission form from tool shed and backedn will run the version of the tool you need.
 
 [Top](#contents)
 
## Import_workflow
To import mint workflow click on the workflow tab and then import workflow

Wokflow files are stored in data folder with .ga extension. Workflow needs all the tools installed before 
Importing . 
To run the pulldown alignment step in mint workflow, either import the workflow(Galaxy-Workflow-pulldown_align.ga) or create one using create workflow option.

Below are the images of the all the workflows in Mint Pipleline. Each tool is marked according to the source of the tool either shed tool (red) ,custom tool(blue) or prebuilt(yellow).

<img src="https://github.com/psnehal/GalaxyScreenshots/blob/master/pulldown_Align.png" width="100">
<img src="https://github.com/psnehal/GalaxyScreenshots/blob/master/pulldown_sample.png" width="100">
<img src="https://github.com/psnehal/GalaxyScreenshots/blob/master/pulldown_compare.png" width="100">
<img src="https://github.com/psnehal/GalaxyScreenshots/blob/master/bisulfite_align.png" width="100">
<img src="https://github.com/psnehal/GalaxyScreenshots/blob/master/bisulfite_sample.png" width="100">
<img src="https://github.com/psnehal/GalaxyScreenshots/blob/master/bisulfite_compare.png" width="100">
<img src="https://github.com/psnehal/GalaxyScreenshots/blob/master/sample_classification.png" width="100">
<img src="https://github.com/psnehal/GalaxyScreenshots/blob/master/Compare_classification.png" width="100">





            

