# mint_galaxy
Galaxy pipeline for the Mint 

## Contents

* [Overview](#overview)
* [Galaxy Installation](#installation)
* [Customize Galaxy Instance](#customize)
	* [Change galaxy.ini file](#galaxy_ini)
		* [Add admin](#add_admin)
		* [Change config file extensions](#change_config_file_extensions) 
	* [Change tool_conf.xml file](#change_tool_config) 	
* [Add tools](#add_tools)		
	* [Custom tools](#custom)
	* [Tool shed tools](#tool_shed)	

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

## Customize
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
Change below parameters  in the galaxy.ini file: 
```
tool_config_file = config/tool_conf.xml, config/shed_tool_conf.xml
retry_metadata_internally = False
job_working_directory = database/job_working_directory
tool_data_table_config_path = config/tool_data_table_conf.xml
tool_sheds_config_file = config/tool_sheds_conf.xml
```



[Top](#contents)
## Add tools

### Custom
  
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

and also copy all the folders from tools folder.
For custom tools, back-end installation of tools is required . Refer to the install_tools.sh file on github.
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
  macs2 v2.1.0.20140616 (package_macs2_2_1_0_20151222' 
	samtools(1.2):samtools v0.1.19 (samtools package 1.2 iuc and then samtools sort 1.2 by devteam )
  sort sam_to_bam(devteams)
  trim_galore v0.4.1
  fastq groomer 
```
Select the one required by mint pipeline. Version number are important. For .e.g for samtools its 1.9.
If you want to use already created workflow then you will need to install exactly same the tools mentioned below.

 
 [Top](#contents)

Galaxy Installation: 

            

