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
Refer to https://new.galaxyproject.org/Admin/GetGalaxy/  link for additional questions. 
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
  bedtools v2.25.0
  bismark v0.16.1 
  FastQC v0.11.5
  macs2 v2.1.0.20140616 (package_macs2_2_1_0_20151222)
  samtools(1.2):samtools v0.1.19 (samtools package 1.2 iuc and then samtools sort & same_to_bam 1.2 by devteam )
  trim_galore v0.4.1
  fastq groomer 
```
Version number are important while installing tools If you want to use already created workflow.
NOTE: Sometimes tool shed tools are failed to install at the backend(e.g. multiqc). You can refer to install.sh script in repository to install tools.This way you will submission form from tool shed and backedn will run the version of the tool you need.
 
 [Top](#contents)
 
## Import_workflow
To import mint workflow click on the workflow tab and then import workflow

Wokflow files are stored in data folder with .ga extension. Workflow needs all the tools installed before 
Importing . 
To run the pulldown alignment step in mint workflow, either import the workflow(Galaxy-Workflow-pulldown_align.ga) or create one using create workflow option.

![image](https://github.com/psnehal/GalaxyScreenshots/blob/master/pulldown_Align.png "Pulldown Align" {width=40px height=400px})





            

