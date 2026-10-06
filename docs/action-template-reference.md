<!--
PANDOC_DEFAULTS_BEGIN
metadata:
  title: "Aspera Orchestrator Action Template Reference"
  author: "IBM Aspera"
PANDOC_DEFAULTS_END
-->

# Aspera Orchestrator 4.1.6 Action Template Reference

> Generated from the Orchestrator `actions` directory: do not edit.
> See the [Workflow Authoring Guide](workflow-authoring-guide.md) for how to use this reference.

For each action plugin, this reference lists:

- **Template attributes**: the fields of an action template, as written in element 3 (action templates) of a workflow file.
  Built from the database migrations of the plugin.
  For a text field left blank in the template, the column **Input if blank** gives the name of the step input that replaces it (see `default_inputs_spec`).
- **Inputs** and **Outputs**: names and types found in methods `inputs_spec` and `outputs_spec` of the plugin class.
  They are extracted from source text: when the method computes names at run time (for example from a template field), the list is incomplete and a note says so.
  Every step also has output `Step_information` (`hash`).
- **Default**: the database default of the attribute, or, marked `(code)`, the value used by the plugin when the attribute is blank.

## Index

| Plugin | Display name | Category | Version |
|--------|--------------|----------|---------|
| [Adi3Parser](#adi3parser) | ADI 3 Parser and Validator | Quality Control | 0.2.2 |
| [AdiParser](#adiparser) | ADI Parser and Validator | Quality Control | 0.5.2 |
| [AdiTransformation](#aditransformation) | ADI Transformation | File Transformations | 0.1.0 |
| [AkamaiTranscoding](#akamaitranscoding) | Akamai transcoding | Transcoding | 0.1.0 |
| [AlchemistSnellOdOperation](#alchemistsnellodoperation) | Alchemist Snell OD operations | Transcoding | 0.2.2 |
| [AmazonDynamodbOperation](#amazondynamodboperation) | Amazon DynamoDB Operation | Integration | 0.4.1 |
| [AmazonElasticTranscoding](#amazonelastictranscoding) | Amazon Elastic Transcoder | Transcoding | 0.4.0 |
| [AmazonGlacierOperation](#amazonglacieroperation) | Amazon Glacier Operation | Integration | 0.7.1 |
| [AmazonMediaConvertOperation](#amazonmediaconvertoperation) | Amazon Media Convert Operation | Integration | 0.2.2 |
| [AmazonS3Operation](#amazons3operation) | Amazon S3 Operation | Integration | 1.3.1 |
| [AmazonSimpledbOperation](#amazonsimpledboperation) | Amazon SimpleDB Operation | Integration | 0.4.0 |
| [AmazonSnsOperation](#amazonsnsoperation) | Amazon SNS Operation | Integration | 0.4.1 |
| [AmazonSqsOperation](#amazonsqsoperation) | Amazon SQS Operation | Integration | 0.5.1 |
| [AmazonSqsTrigger](#amazonsqstrigger) | Amazon SQS trigger | Triggers | 0.4.4 |
| [AmazonSwfOperation](#amazonswfoperation) | Amazon SWF Operation | Integration | 0.4.0 |
| [AmazonTranscribeOperation](#amazontranscribeoperation) | Amazon Transcribe Operation | Integration | 0.3.0 |
| [AmberfinTranscoding](#amberfintranscoding) | Amberfin transcoding | Transcoding | 0.3.0 |
| [AmqpMessage](#amqpmessage) | AMQP message | Integration | 0.9.1 |
| [AmqpTrigger](#amqptrigger) | AMQP trigger | Triggers | 0.9.2 |
| [ArchiveManager](#archivemanager) | Archive manager | File Operations | 0.4.1 |
| [ArrayFanout](#arrayfanout) | Array fan-out | System | 1.2.2 |
| [AscpClient](#ascpclient) | Ascp client | File Transfer | 1.6.2 |
| [AsperaCentralWatcher](#asperacentralwatcher) | Aspera central watcher | Triggers | 2.8.2 |
| [AsperaFilesPackageDelivery](#asperafilespackagedelivery) | AoC Package Delivery | File Transfer | 0.5.1 |
| [AsperaFilesPackageWatcher](#asperafilespackagewatcher) | AoC Package Watcher | Triggers | 0.6.3 |
| [AsperaNodeApi](#asperanodeapi) | Aspera Node API | File Operations | 0.2.1 |
| [AsperaNodeApiTransferMonitor](#asperanodeapitransfermonitor) | Aspera Node API Transfer Monitor | Triggers | 0.3.3 |
| [AsperaNodeApiTransferOperation](#asperanodeapitransferoperation) | Aspera Node API Transfer | File Transfer | 1.3.2 |
| [AsperaNodeFileWatcher](#asperanodefilewatcher) | Aspera node file watcher | Triggers | 0.9.5 |
| [AsperaNodeSearch](#asperanodesearch) | Aspera Node Search | File Operations | 0.3.1 |
| [AsperaOnCloudManagement](#asperaoncloudmanagement) | Aspera On Cloud Management | Integration | 0.3.1 |
| [AsperaOtfv](#asperaotfv) | Aspera Out-of-Transfer File Validation | File Transfer | 0.1.2 |
| [AsperaSharesManagement](#asperasharesmanagement) | Aspera Shares Management | Other Utilities | 0.1.1 |
| [AsyncRemoteExecution](#asyncremoteexecution) | Async Remote Execution | Integration | 0.6.4 |
| [AtemeTranscoding](#atemetranscoding) | Ateme transcoding | Transcoding | 0.1.1 |
| [AuroraFileVerification](#aurorafileverification) | Aurora file verification | Quality Control | 1.4.0 |
| [AzureServiceBusOperation](#azureservicebusoperation) | Azure Service Bus Operation | Integration | 0.1.1 |
| [AzureServiceBusTrigger](#azureservicebustrigger) | Azure Service Bus Trigger | Integration | 0.1.3 |
| [BatonFileCorrection](#batonfilecorrection) | Baton file correction | Quality Control | 0.5.1 |
| [BatonFileVerification](#batonfileverification) | Baton file verification | Quality Control | 1.8.2 |
| [BatonXmlReport](#batonxmlreport) | Baton xml report | Quality Control | 0.3.1 |
| [BitmovinEncoding](#bitmovinencoding) | Bitmovin encoding | Transcoding | 0.1.0 |
| [CambriaFtcTranscoder](#cambriaftctranscoder) | Cambria ftc transcoder | Other Utilities | 0.1.0 |
| [CarbonCoderTranscoding](#carboncodertranscoding) | Carbon/WFS transcoding | Transcoding | 1.4.1 |
| [CatdvRestRequest](#catdvrestrequest) | CatdvRestRequest | Integration | 0.1.1 |
| [CerifyFileVerification](#cerifyfileverification) | Cerify File Verification | Quality Control | 0.2.0 |
| [ClamavCheck](#clamavcheck) | ClamAV check | Virus Scan | 0.3.1 |
| [CollectionManager](#collectionmanager) | Collection manager | Other Utilities | 0.3.2 |
| [ConsoleNotification](#consolenotification) | Console notification | User Interactions | 0.5.1 |
| [ConsoleSmartTransferOperation](#consolesmarttransferoperation) | Console Smart Transfer | File Transfer | 0.2.1 |
| [ConvertPath](#convertpath) | Path conversion | File Operations | 0.2.1 |
| [CorbaOperation](#corbaoperation) | Corba Operation | Integration | 0.1.2 |
| [CurlOperation](#curloperation) | Curl Operations | Integration | 0.1.1 |
| [CustomProgressNotifier](#customprogressnotifier) | Custom progress notifier | Integration | 0.2.2 |
| [CustomPython](#custompython) | Custom Python | Other Utilities | 0.1.3 |
| [CustomRuby](#customruby) | Custom Ruby | Other Utilities | 0.7.3 |
| [CustomTrigger](#customtrigger) | Custom trigger | Triggers | 0.4.2 |
| [DaletAssetManagement](#daletassetmanagement) | Dalet Asset Management Plugin | Asset Management | 0.2.1 |
| [DatabaseQuery](#databasequery) | Database query | Integration | 0.3.4 |
| [DatabaseTrigger](#databasetrigger) | Database trigger | Triggers | 1.1.6 |
| [DependencyChecker](#dependencychecker) | Dependency checker | Other Utilities | 0.1.1 |
| [DigitalrapidsStreamTranscoding](#digitalrapidsstreamtranscoding) | Imagine StreamZ transcoding | Transcoding | 0.4.0 |
| [DigitalrapidsTmTranscoding](#digitalrapidstmtranscoding) | Imagine TM transcoding | Transcoding | 0.4.1 |
| [DivaArchive](#divaarchive) | Diva archive | File Operations | 0.4.2 |
| [DolbyOperation](#dolbyoperation) | Dolby VM600/DP600 | Transcoding | 0.1.1 |
| [ElementalMediaConvert](#elementalmediaconvert) | Elemental Media Convert | Transcoding | 0.4.2 |
| [ElementalTranscoding](#elementaltranscoding) | Elemental transcoding | Transcoding | 0.7.1 |
| [EmailInboxWatcher](#emailinboxwatcher) | Email inbox watcher | Triggers | 0.4.2 |
| [EmailNotification](#emailnotification) | Email notification | User Interactions | 0.7.4 |
| [EmotionOperation](#emotionoperation) | Emotion operation | Transcoding | 1.2.0 |
| [EncodingdotcomTranscoding](#encodingdotcomtranscoding) | Encoding.com transcoding | Transcoding | 0.3.0 |
| [EnvivioVodEncoding](#enviviovodencoding) | Envivio transcoding | Transcoding | 1.1.0 |
| [EolementheWorkflowManager](#eolementheworkflowmanager) | EolementheWorkflowManager | Transcoding | 0.2.0 |
| [EpisodeTranscoding](#episodetranscoding) | Episode transcoding | Transcoding | 1.2.0 |
| [EvertzMediatorOperation](#evertzmediatoroperation) | Evertz Mediator operation | Asset Management | 0.1.2 |
| [ExiftoolXmpTagger](#exiftoolxmptagger) | Exiftool xmp tagger | File Operations | 0.1.0 |
| [ExitStatus](#exitstatus) | Exit status | System | 0.1.2 |
| [FacebookUploadOperation](#facebookuploadoperation) | Facebook Video Upload Operation | Integration | 0.3.0 |
| [FaspControl](#faspcontrol) | FASP controller | File Transfer | 0.7.1 |
| [FaspTransfer](#fasptransfer) | FASP transfer | File Transfer | 4.3.6 |
| [Faspex5Delivery](#faspex5delivery) | Faspex5 delivery | File Transfer | 0.2.2 |
| [Faspex5FileProcessing](#faspex5fileprocessing) | Faspex5 file processing | File Transfer | 0.0.6 |
| [Faspex5InboxWatcher](#faspex5inboxwatcher) | Faspex5 inbox watcher | Triggers | 0.8.6 |
| [Faspex5PackageMonitor](#faspex5packagemonitor) | Faspex5 package monitor | Triggers | 0.2.2 |
| [Faspstream](#faspstream) | FASPstream | File Transfer | 0.1.1 |
| [FederatedWorkflow](#federatedworkflow) | Federated workflow | System | 0.6.3 |
| [FfmpgTranscoding](#ffmpgtranscoding) | FFMPEG transcoding | Transcoding | 0.6.1 |
| [FfprobeInfo](#ffprobeinfo) | FFProbe Information | File Operations | 0.1.1 |
| [FileArchivingOperation](#filearchivingoperation) | File archiving operation | File Operations | 0.4.1 |
| [FileGenerator](#filegenerator) | File generator | File Operations | 0.5.1 |
| [FileInfo](#fileinfo) | File information | File Operations | 0.2.1 |
| [FileJournalLogEntry](#filejournallogentry) | File journal log entry | Other Utilities | 0.4.2 |
| [Filter](#filter) | Filter | System | 0.3.1 |
| [FlicsTranscoding](#flicstranscoding) | Flics transcoding | Transcoding | 0.1.1 |
| [FlipFactoryTransformation](#flipfactorytransformation) | FlipFactory transcoding | Transcoding | 1.2.0 |
| [FrameioOperation](#frameiooperation) | Frameio Operation | Integration | 0.3.2 |
| [FtpFolderTrigger](#ftpfoldertrigger) | FTP Folder Trigger | Triggers | 0.1.2 |
| [FtpTransfer](#ftptransfer) | FTP transfer | File Transfer | 1.3.1 |
| [FtpTrigger](#ftptrigger) | FTP Trigger | Triggers | 2.2.2 |
| [FtpsTransfer](#ftpstransfer) | Ftps transfer | File Transfer | 0.1.1 |
| [Funnelin](#funnelin) | Funnel-in | System | 1.1.3 |
| [FxpTransfer](#fxptransfer) | FXP Transfer | File Transfer | 0.3.1 |
| [GoogleCloudstorageOperation](#googlecloudstorageoperation) | Google Cloud Storage Operation | Integration | 0.1.1 |
| [GooglePubsubOperation](#googlepubsuboperation) | Google Pubsub Operation | Integration | 0.1.1 |
| [HandbrakeTranscoding](#handbraketranscoding) | HandBrake transcoding | Transcoding | 0.1.0 |
| [HelloWorld](#helloworld) | Hello world | Other Utilities | 1.3.1 |
| [HttpTransfer](#httptransfer) | HTTP Transfer | File Transfer | 0.2.2 |
| [HybrikTranscoder](#hybriktranscoder) | Hybrik Transcoder | Transcoding | 0.1.2 |
| [IbmMqIntegration](#ibmmqintegration) | Ibm mq integration | Integration | 0.5.4 |
| [IbmMqMftTransfer](#ibmmqmfttransfer) | Ibm mq mft transfer | Integration | 0.5.3 |
| [IcapVirusScan](#icapvirusscan) | ICAP virus scan | Virus Scan | 0.1.0 |
| [Imagemagick](#imagemagick) | Imagemagick | File Transformations | 0.1.3 |
| [InfluxdbOperation](#influxdboperation) | InfluxDB | Integration | 0.1.1 |
| [InputManipulation](#inputmanipulation) | Input Manipulations | Other Utilities | 0.1.1 |
| [IrtMxfAnalyser](#irtmxfanalyser) | Irt mxf analyser | Quality Control | 0.1.0 |
| [IsmM3u8Parser](#ismm3u8parser) | ISM and M3U8 File Parser | File Operations | 0.1.0 |
| [ItunesTransporter](#itunestransporter) | iTunes transporter | File Transfer | 0.2.2 |
| [JiraOperation](#jiraoperation) | JIRA Ticket Creation | Integration | 0.2.0 |
| [KafkaStream](#kafkastream) | Kafka stream | Integration | 0.1.3 |
| [LoadBalancer](#loadbalancer) | Load balancer | Other Utilities | 0.1.1 |
| [LoadManager](#loadmanager) | Load manager | Resources | 0.5.3 |
| [LocalExecution](#localexecution) | Local execution | Integration | 0.4.1 |
| [LocalFileOperation](#localfileoperation) | Local file operation | File Operations | 1.2.1 |
| [LocalFilePermission](#localfilepermission) | Local file permission | File Operations | 0.1.2 |
| [LocalFileWatcher](#localfilewatcher) | Local file watcher | Triggers | 1.9.3 |
| [LocalFolderWatcher](#localfolderwatcher) | Local folder watcher | Triggers | 1.6.3 |
| [MacCaptionOperation](#maccaptionoperation) | MacCaption Operation | File Transformations | 0.2.0 |
| [MarquisMewsOperation](#marquismewsoperation) | Marquis Mews Operation | Transcoding | 0.1.0 |
| [MassParameterSetter](#massparametersetter) | Stored parameter set | Other Utilities | 0.6.6 |
| [McAfeeVirusCheck](#mcafeeviruscheck) | McAfee virus check | Virus Scan | 0.2.0 |
| [Md5Checksum](#md5checksum) | MD5 checksum | File Operations | 0.3.1 |
| [MediaInfo](#mediainfo) | Media info | File Operations | 0.7.1 |
| [MediaMateOperation](#mediamateoperation) | Media Mate Operation | Integration | 0.3.2 |
| [MediabinAssetManagement](#mediabinassetmanagement) | Mediabin asset management | File Operations | 0.1.0 |
| [MergePoint](#mergepoint) | Merge point | System | 0.5.2 |
| [MimirOperation](#mimiroperation) | Mimir Operation | Integration | 1.0.0 |
| [MinnetonkaAudiotoolserver](#minnetonkaaudiotoolserver) | Minnetonka AudioTools Server | Transcoding | 0.3.0 |
| [MogMxfSpeedrail](#mogmxfspeedrail) | MOG MXF Speedrail | Transcoding | 0.2.0 |
| [MongodbOperation](#mongodboperation) | Mongodb operation | Integration | 1.3.3 |
| [MxFixer](#mxfixer) | Mx fixer | Quality Control | 0.2.0 |
| [MxfLegalizer](#mxflegalizer) | MXF Legalizer | File Transformations | 0.2.0 |
| [OpswatMetadefender](#opswatmetadefender) | Opswat metadefender | Virus Scan | 0.1.0 |
| [OrchestratorAlertEntry](#orchestratoralertentry) | Orchestrator Alert Configuration | System | 0.1.1 |
| [OrionOttMonitor](#orionottmonitor) | Orion OTT Monitor | Quality Control | 0.3.0 |
| [PasswordGenerator](#passwordgenerator) | Password generator | Other Utilities | 0.1.1 |
| [PulsarContentVerification](#pulsarcontentverification) | Pulsar content verification | Quality Control | 0.2.0 |
| [QscanFileVerification](#qscanfileverification) | QScan file verification | Quality Control | 0.1.0 |
| [QuasarVeneraQcOperation](#quasarveneraqcoperation) | Quasar Venera QC | Quality Control | 0.1.0 |
| [QueueStager](#queuestager) | Queue stager | Other Utilities | 0.9.5 |
| [RegexMatcher](#regexmatcher) | Regex matcher | Other Utilities | 0.1.1 |
| [RemoteExecution](#remoteexecution) | Remote execution | Integration | 1.2.2 |
| [RemoteFileOperation](#remotefileoperation) | Remote file operation | File Operations | 0.3.2 |
| [RemoteFileWatcher](#remotefilewatcher) | Remote file watcher | Triggers | 2.4.3 |
| [RemoteFolderWatcher](#remotefolderwatcher) | Remote folder watcher | Triggers | 0.2.4 |
| [ResourceManager](#resourcemanager) | Resource manager | Other Utilities | 2.3.3 |
| [RestRequest](#restrequest) | REST request | Integration | 1.2.4 |
| [RobocopyOperation](#robocopyoperation) | Robocopy | File Transfer | 0.1.1 |
| [RssFeedReader](#rssfeedreader) | RSS Feed Reader | User Interactions | 0.5.2 |
| [ScheduleTrigger](#scheduletrigger) | Schedule trigger | Triggers | 1.2.3 |
| [ScomNotification](#scomnotification) | SCOM notification | User Interactions | 1.2.0 |
| [ScpTransfer](#scptransfer) | SCP transfer | File Transfer | 0.2.1 |
| [SftpTransfer](#sftptransfer) | SFTP transfer | File Transfer | 0.7.1 |
| [SftpTrigger](#sftptrigger) | SFTP trigger | Triggers | 0.4.3 |
| [SglFlashnetArchive](#sglflashnetarchive) | SglFlashnetArchive | File Operations | 0.1.0 |
| [SharedStateOperation](#sharedstateoperation) | Shared state operation | Other Utilities | 0.5.1 |
| [SharesTransferSetup](#sharestransfersetup) | Shares transfer setup | File Transfer | 0.1.1 |
| [ShowMgrOperation](#showmgroperation) | ShowMgr | Asset Management | 0.2.0 |
| [SimpleParameterLookup](#simpleparameterlookup) | Look-up table | Other Utilities | 0.8.8 |
| [SlackNotification](#slacknotification) | Slack notification | User Interactions | 0.2.2 |
| [SnapshotPlugin](#snapshotplugin) | Snapshot | System | 0.2.1 |
| [SoapRequest](#soaprequest) | Soap request | Integration | 2.1.7 |
| [SoapRequestListener](#soaprequestlistener) | Soap request listener | Triggers | 0.2.4 |
| [SoftlayerApi](#softlayerapi) | Softlayer API | Integration | 0.2.3 |
| [SonyCi](#sonyci) | Sony Ci | Asset Management | 0.2.2 |
| [SonyCiFileWatcher](#sonycifilewatcher) | SonyCi file watcher | Triggers | 0.1.3 |
| [SpreadsheetParser](#spreadsheetparser) | Spreadsheet parser | File Operations | 0.2.1 |
| [SubWorkflow](#subworkflow) | Sub-workflow | System | 1.5.4 |
| [SublerOperation](#subleroperation) | Subler Operation | File Transformations | 0.1.0 |
| [SymantecIcapDlpOperation](#symantecicapdlpoperation) | Symantec Icap DLP Operations | Virus Scan | 0.1.0 |
| [SymantecIcapVirusScanOperation](#symantecicapvirusscanoperation) | Symantec Icap Virus Scan Operations | Virus Scan | 0.4.0 |
| [SymantecPgp](#symantecpgp) | PGP encryption | File Operations | 0.4.0 |
| [ThePlatform](#theplatform) | The Platform | Asset Management | 0.4.0 |
| [ThreePlayOperation](#threeplayoperation) | 3PlayMedia Operation | Other Utilities | 0.1.0 |
| [TimecodeManager](#timecodemanager) | Timecode manager | Transcoding | 0.3.1 |
| [UnifiedPackager](#unifiedpackager) | Unified packager | Transcoding | 0.1.0 |
| [UserInput](#userinput) | User input | User Interactions | 0.8.2 |
| [UserLookup](#userlookup) | User lookup | System | 0.1.1 |
| [UuidGenerator](#uuidgenerator) | UUID Generator | Other Utilities | 0.3.1 |
| [VantageTranscoding](#vantagetranscoding) | Vantage Transcoding | Transcoding | 1.0.1 |
| [VidcheckerVerification](#vidcheckerverification) | Vidchecker verification | Quality Control | 0.4.2 |
| [VqbifAnalyzer](#vqbifanalyzer) | VqbifAnalyzer | Quality Control | 0.1.0 |
| [VqmaAnalyzer](#vqmaanalyzer) | VqmaAnalyzer | Transcoding | 0.1.0 |
| [WatchFileMovement](#watchfilemovement) | Watch file movement | Other Utilities | 0.1.1 |
| [WatsonLanguageTranslator](#watsonlanguagetranslator) | Watson Language Translator | Integration | 0.1.0 |
| [WatsonSpeechToText](#watsonspeechtotext) | Watson speech to text | Quality Control | 0.2.1 |
| [WatsonTextToSpeech](#watsontexttospeech) | Watson text to speech | Quality Control | 0.2.1 |
| [WatsonVideoEnrichment](#watsonvideoenrichment) | Watson video enrichment | Quality Control | 0.1.0 |
| [WebdavTransfer](#webdavtransfer) | WebDAV Operation | File Transfer | 0.3.1 |
| [WorkOrderMetaData](#workordermetadata) | Work Order Metadata | System | 0.7.1 |
| [WorkflowLauncher](#workflowlauncher) | Workflow launcher | System | 1.6.1 |
| [XfConverter](#xfconverter) | Xf converter | Transcoding | 0.3.0 |
| [XmlParsing](#xmlparsing) | Xml Parsing | Other Utilities | 0.1.3 |
| [XsdValidation](#xsdvalidation) | XSD Validation | Quality Control | 0.2.1 |
| [XsltTransformation](#xslttransformation) | XSLT Transformation | File Transformations | 0.1.1 |
| [XytechMediaPulse](#xytechmediapulse) | XytechMediaPulse | Asset Management | 0.1.0 |
| [ZencoderTranscoding](#zencodertranscoding) | Zencoder transcoding | Transcoding | 0.3.2 |

## Adi3Parser

- **Display name**: ADI 3 Parser and Validator
- **Category**: Quality Control
- **Version**: 0.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides ability to parse and/or validate contents of ADI 3.0 XML

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `adi_file_path` | string |  | `Adi_file_path` |
| `validate_fields` | text |  |  |
| `pass_on_missing_files` | boolean |  |  |
| `check_filesizes` | boolean |  |  |
| `check_filemd5s` | boolean |  |  |
| `adi_package_dir` | string |  | `Adi_package_dir` |
| `validate_xsd` | boolean |  |  |
| `xsd_path` | string |  |  |
| `adi_format` | string |  |  |

### Inputs

- `Adi_file_path` (`string`, required)
- `Adi_package_dir` (`string`, optional)
- `Check_Filemd5s` (`flag`)
- `Check_Filesizes` (`flag`)
- `Pass_On_Missing_Files` (`flag`)

### Outputs

- `List_of_Filenames` (`array`)
- `Count_of_ContentFiles` (`int`)
- `ADI_Size_Hash` (`hash`)
- `ADI_MD5_Hash` (`hash`)
- `ADI_Package_Metadata` (`hash`)
- `Is_Valid_ADI  ` (`flag`)
- `Filetype_list` (`hash`)
- `Asset_IDs_hash` (`hash`)
- `Asset_IDs_FileName_hash` (`hash`)
- `ADI Fields Data Hash` (`hash`)
- `Filesizes_validation` (`flag`)
- `Failed_Filesize_Assets` (`array`)
- `FileMD5s_validation` (`flag`)
- `Failed_MD5_Assets` (`array`)
- `XSD_Validation` (`flag`)
- `XSD_Validation_Error_Message` (`string`)
- `URI Ids List` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## AdiParser

- **Display name**: ADI Parser and Validator
- **Category**: Quality Control
- **Version**: 0.5.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides ability to parse and/or validate contents of ADI XML

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `adi_file_path` | string |  | `Adi_file_path` |
| `adi_version` | string |  |  |
| `validate_fields` | text |  |  |
| `pass_on_missing_files` | boolean |  |  |
| `check_filesizes` | boolean |  |  |
| `check_filemd5s` | boolean |  |  |
| `adi_package_dir` | string |  | `Adi_package_dir` |
| `check_dtd_file` | boolean |  |  |
| `dtd_file_path` | text |  | `Dtd_file_path` |
| `validate_xsd` | boolean | `false` |  |
| `xsd_path` | string |  | `Xsd_path` |
| `strict_optional_validation` | boolean | `false` |  |

### Inputs

- `Adi_file_path` (`string`, required)
- `Adi_package_dir` (`string`, optional)
- `Dtd_file_path` (`string`, optional)
- `Xsd_path` (`string`, optional)
- `ADI_FILEPATH` (`string`)
- `Check_Dtd_File` (`flag`)
- `Check_Filemd5s` (`flag`)
- `Check_Filesizes` (`flag`)
- `Pass_On_Missing_Files` (`flag`)

### Outputs

- `List_of_Filenames` (`array`)
- `Count_of_ContentFiles` (`int`)
- `ADI_Size_Hash` (`hash`)
- `ADI_MD5_Hash` (`hash`)
- `ADI_Package_Metadata` (`hash`)
- `Is_Valid_ADI` (`flag`)
- `Filetype_list` (`hash`)
- `Asset_IDs_hash` (`hash`)
- `Asset_IDs_FileName_hash` (`hash`)
- `Class_Info_FileName_hash` (`hash`)
- `Filesizes_validation` (`flag`)
- `Failed_Filesize_Assets` (`array`)
- `FileMD5s_validation` (`flag`)
- `Failed_MD5_Assets` (`array`)
- `DTD_Validation` (`flag`)
- `DTD_Validation_Error_Message` (`string`)
- `Field_Validation_Error_Message` (`array`)
- `XSD_Validation` (`flag`)
- `Title_class_hash` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## AdiTransformation

- **Display name**: ADI Transformation
- **Category**: File Transformations
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plugin provides ability to convert ADI 1.1 version compliant XML files to ADI 3.0 version and vice versa

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `adi_file_path` | string |  | `Adi_file_path` |
| `adi_version` | string |  |  |
| `xsl_file_path` | string |  | `Xsl_file_path` |
| `target_path` | string |  | `Target_path` |
| `jar_path` | string |  |  |

### Inputs

- `Adi_file_path` (`string`, required)
- `Xsl_file_path` (`string`, required)
- `Target_path` (`string`, optional)

### Outputs

- `Output File Path` (`string`)
- `Is_Valid_ADI` (`flag`)
- `Is_Valid_xsl` (`flag`)
- `Source ADI File Archive path` (`string`)
- `ADI_Hash` (`hash`)
- `ADI_XML` (`string`)
- `Step_information` (`hash`)

## AkamaiTranscoding

- **Display name**: Akamai transcoding
- **Category**: Transcoding
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plugin starts and monitors a Transcoding job using the Akamai Transcoding platform.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `user_name` | string |  |  |
| `active_password` | string |  |  |
| `workspace_id` | string |  |  |
| `library_id` | string |  |  |
| `origin_id` | string |  |  |
| `collection` | string |  |  |
| `source_file` | string |  |  |
| `target_path` | string | `/transcoded` (code) |  |
| `media_library_id` | string |  |  |
| `media_library_origin_id` | string |  |  |
| `target_name` | string |  |  |
| `remove_source_after_transcoding` | boolean | `false` (code) |  |
| `polling_frequency` | integer | `5` (code) |  |

### Inputs

- None found in source.

### Outputs

- `Output object` (`string`)
- `Status message` (`string`)
- `Result code` (`int`)
- `Step_information` (`hash`)

## AlchemistSnellOdOperation

- **Display name**: Alchemist Snell OD operations
- **Category**: Transcoding
- **Version**: 0.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to control Alchemist Snell OD systems.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `url` | text |  | `Url` |
| `payload` | mediumtext |  | `Payload` |
| `operation` | text |  | `Operation` |
| `polling_frequency` | integer | `10` (code) | `Polling_frequency` |

### Inputs

- `Url` (`string`, required)
- `Payload` (`string`, required)
- `Operation` (`string`, required)
- `Polling_frequency` (`int`, optional)
- `Response Received` (`hash`)
- `Resouce_Id` (`string`)
- `Error Message` (`hash`)
- `Responce_XML_For_Job_Submit` (`hash`)

### Outputs

- `Response Received` (`hash`)
- `Resouce_Id` (`string`)
- `Error Message` (`hash`)
- `Responce_XML_For_Job_Submit` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AmazonDynamodbOperation

- **Display name**: Amazon DynamoDB Operation
- **Category**: Integration
- **Version**: 0.4.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-ins can be used to interact with Amazon DynamoDB.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  | `Operation` |
| `aws_key` | string |  | `Aws_key` |
| `aws_secret` | string |  | `Aws_secret` |
| `aws_region` | string |  | `Aws_region` |
| `table_name` | string |  | `Table_name` |
| `attr_hash` | text |  |  |
| `verify_ssl` | boolean | `true` |  |
| `proxy_url` | string |  | `Proxy_url` |
| `external_id` | string |  | `External_id` |
| `policy` | text |  | `Policy` |
| `role_arn` | string |  | `Role_arn` |
| `token_duration` | integer | `3600` (code) | `Token_duration` |

### Inputs

- `Aws_key` (`string`, required)
- `Aws_secret` (`string`, required)
- `Aws_region` (`string`, optional)
- `Operation` (`string`, required)
- `Proxy_url` (`string`, optional)
- `External_id` (`string`, optional)
- `Policy` (`string`, optional)
- `Role_arn` (`string`, optional)
- `Token_duration` (`int`, optional)
- `Table_name` (`string`, required)
- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Item` (`hash`)
- `Error Message` (`string`)
- `Items` (`hash`)
- `Item Collection Metrics` (`hash`)
- `Input hash` (`hash`)
- `Aws_session_token` (`pwd`)

### Outputs

- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Item` (`hash`)
- `Error Message` (`string`)
- `Items` (`hash`)
- `Item Collection Metrics` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AmazonElasticTranscoding

- **Display name**: Amazon Elastic Transcoder
- **Category**: Transcoding
- **Version**: 0.4.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to use Amazon Elastic Transcoder

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `aws_key` | string |  | `Aws_key` |
| `aws_secret` | string |  | `Aws_secret` |
| `aws_region` | string |  | `Aws_region` |
| `aws_inputs` | text | `[]` (code) | `Aws_inputs` |
| `pipeline_id` | string |  | `Pipeline_id` |
| `aws_outputs` | text | `[]` (code) | `Aws_outputs` |
| `output_key_prefix` | string |  | `Output_key_prefix` |
| `user_metadata` | text | `[]` (code) | `User_metadata` |
| `playlists` | text | `[]` (code) | `Playlists` |
| `verify_ssl` | boolean | `true` |  |
| `proxy_url` | string |  | `Proxy_url` |
| `external_id` | string |  | `External_id` |
| `policy` | text |  | `Policy` |
| `role_arn` | string |  | `Role_arn` |
| `token_duration` | integer | `3600` (code) | `Token_duration` |

### Inputs

- `Aws_key` (`string`, required)
- `Aws_secret` (`string`, required)
- `Aws_region` (`string`, optional)
- `Proxy_url` (`string`, optional)
- `External_id` (`string`, optional)
- `Policy` (`string`, optional)
- `Role_arn` (`string`, optional)
- `Token_duration` (`int`, optional)
- `Pipeline_id` (`string`, required)
- `Aws_inputs` (`string`, optional)
- `Aws_outputs` (`string`, optional)
- `Output_key_prefix` (`string`, optional)
- `User_metadata` (`string`, optional)
- `Playlists` (`string`, optional)
- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Response` (`string` or `hash`)
- `Error_Message` (`string`)
- `Aws_session_token` (`pwd`)

### Outputs

- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Response` (`string` or `hash`)
- `Error_Message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AmazonGlacierOperation

- **Display name**: Amazon Glacier Operation
- **Category**: Integration
- **Version**: 0.7.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to integrate with Amazon Glacier Service.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `aws_key` | string |  | `Aws_key` |
| `aws_secret` | string |  | `Aws_secret` |
| `aws_region` | string |  | `Aws_region` |
| `vault_name` | string |  | `Vault_name` |
| `account_id` | string |  | `Account_id` |
| `archive_description` | text | `` (code) | `Archive_description` |
| `checksum` | string | `` (code) | `Checksum` |
| `body` | text |  | `Body` |
| `archive_id` | string |  | `Archive_id` |
| `verify_ssl` | boolean | `false` |  |
| `upload_a_payload` | boolean | `false` |  |
| `upload_file_path` | string |  | `Upload_file_path` |
| `proxy_url` | string |  | `Proxy_url` |
| `external_id` | string |  | `External_id` |
| `policy` | text |  | `Policy` |
| `role_arn` | string |  | `Role_arn` |
| `token_duration` | integer | `3600` (code) | `Token_duration` |

### Inputs

- `Aws_key` (`string`, required)
- `Aws_secret` (`string`, required)
- `Aws_region` (`string`, optional)
- `Proxy_url` (`string`, optional)
- `External_id` (`string`, optional)
- `Policy` (`string`, optional)
- `Role_arn` (`string`, optional)
- `Token_duration` (`int`, optional)
- `Vault_name` (`string`, required)
- `Account_id` (`string`, required)
- `Archive_description` (`string`, optional)
- `Checksum` (`string`, optional)
- `Body` (`string`, required)
- `Upload_file_path` (`string`, required)
- `Archive_id` (`string`, required)
- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Response` (`string`)
- `Location` (`string`)
- `CheckSum` (`string`)
- `Archive_Id` (`string`)
- `Error_Message` (`string`)
- `Response_Hash` (`hash`)
- `Aws_session_token` (`pwd`)

### Outputs

- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Response` (`string`)
- `Location` (`string`)
- `CheckSum` (`string`)
- `Archive_Id` (`string`)
- `Error_Message` (`string`)
- `Response_Hash` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AmazonMediaConvertOperation

- **Display name**: Amazon Media Convert Operation
- **Category**: Integration
- **Version**: 0.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to integrate with Amazon Media Convert Service.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `aws_key` | string |  | `Aws_key` |
| `aws_secret` | string |  | `Aws_secret` |
| `aws_region` | string |  | `Aws_region` |
| `mode` | string |  | `Mode` |
| `role` | string |  | `Role` |
| `job_id` | string |  | `Job_id` |
| `settings_path` | string |  | `Settings_path` |
| `api_endpoint` | string |  |  |
| `polling_frequency` | string | `10` (code) |  |
| `proxy_url` | string |  | `Proxy_url` |

### Inputs

- `Aws_key` (`string`, required)
- `Aws_secret` (`string`, required)
- `Aws_region` (`string`, optional)
- `Proxy_url` (`string`, optional)
- `Mode` (`string`, required)
- `Role` (`string`, required)
- `Settings_path` (`string`, required)
- `Job_id` (`string`, required)
- `Aws_session_token` (`pwd`)

### Outputs

- `Response` (`hash`)
- `Run_Id` (`string`)
- `Error_Message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AmazonS3Operation

- **Display name**: Amazon S3 Operation
- **Category**: Integration
- **Version**: 1.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to execute file and bucket operations (such as upload, download, copy, list, and delete) on Amazon S3 storage.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `aws_key` | string |  | `Aws_key` |
| `aws_secret` | string |  | `Aws_secret` |
| `aws_region` | string |  | `Aws_region` |
| `bucket` | string |  | `Bucket` |
| `object_key` | string |  | `Object_key` |
| `local_file_path` | string |  | `Local_file_path` |
| `make_public` | boolean |  |  |
| `restore_version_id` | string |  | `Restore_version_id` |
| `restore_days` | integer |  | `Restore_days` |
| `restore_tier` | string |  | `Restore_tier` |
| `request_payer` | string |  | `Request_payer` |
| `use_accelerate_endpoint` | boolean | `false` (code) | `Use_accelerate_endpoint` |
| `verify_ssl` | boolean | `false` |  |
| `multipart_thread_limit` | integer | `5` (code) |  |
| `multipart_chunk_size` | bigint | `5242880` (code) |  |
| `multipart_upload_threshold` | bigint | `62914560` (code) |  |
| `allow_multipart_upload` | boolean | `false` |  |
| `overwrite_existing_file` | boolean | `false` |  |
| `s3_file_path` | string |  | `S3_file_path` |
| `proxy_url` | string |  | `Proxy_url` |
| `method_type` | string |  | `Method_type` |
| `expires_in` | integer | `900` (code) | `Expires_in` |
| `encode_flag` | boolean | `true` |  |
| `source_region` | string |  | `Source_region` |
| `endpoint_url` | string |  | `Endpoint_url` |
| `force_path_style` | boolean | `false` |  |
| `storage_class` | string |  | `Storage_class` |
| `prefix` | string | `` (code) | `Prefix` |
| `delimiter` | string | `` (code) | `Delimiter` |
| `start_after` | string | `` (code) | `Start_after` |
| `acl` | string | `Select` (code) |  |
| `external_id` | string |  | `External_id` |
| `policy` | text |  | `Policy` |
| `role_arn` | string |  | `Role_arn` |
| `token_duration` | integer | `3600` (code) | `Token_duration` |

### Inputs

- `Aws_key` (`string`, required)
- `Aws_secret` (`string`, required)
- `Aws_region` (`string`, optional)
- `Proxy_url` (`string`, optional)
- `Endpoint_url` (`string`, optional)
- `External_id` (`string`, optional)
- `Policy` (`string`, optional)
- `Role_arn` (`string`, optional)
- `Token_duration` (`int`, optional)
- `Object_key` (`string`, required)
- `Bucket` (`string`, required)
- `Local_file_path` (`string`, required)
- `Storage_class` (`string`, optional)
- `Restore_version_id` (`string`, optional)
- `Restore_tier` (`string`, required)
- `Restore_days` (`int`, required)
- `Request_payer` (`string`, optional)
- `Use_accelerate_endpoint` (`flag`, optional)
- `S3_file_path` (`string`, required)
- `Source_region` (`string`, required)
- `Method_type` (`string`, required)
- `Expires_in` (`int`, optional)
- `Prefix` (`string`, optional)
- `Delimiter` (`string`, optional)
- `Start_after` (`string`, optional)
- `Acl` (`string`)
- `Aws_session_token` (`pwd`)

### Outputs

- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `ETag` (`string`)
- `File_Uploaded` (`string`)
- `Error_Message` (`string`)
- `Object_Key` (`string`)
- `Version_Id` (`string`)
- `Location` (`string`)
- `Bucket` (`string`)
- `Aws_Response` (`hash`)
- `Bucket_List` (`array`)
- `Pre-signed_Url` (`string`)
- `Objects_List` (`array`)
- `Objects_Count` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AmazonSimpledbOperation

- **Display name**: Amazon SimpleDB Operation
- **Category**: Integration
- **Version**: 0.4.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to execute SimpleDB operations

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `aws_key` | string |  | `Aws_key` |
| `aws_secret` | string |  | `Aws_secret` |
| `aws_region` | string |  | `Aws_region` |
| `domain_name` | string |  | `Domain_name` |
| `item_name` | string |  | `Item_name` |
| `select_expression` | string |  | `Select_expression` |
| `attributes_put_list` | text |  |  |
| `attributes_list` | text |  |  |
| `items_put_list` | text |  |  |
| `items_delete_list` | text |  |  |
| `attributes_names_list` | text |  |  |
| `next_token` | string |  | `Next_token` |
| `consistent_read` | boolean | `false` (code) | `Consistent_read` |
| `max_number_of_domains` | integer |  | `Max_number_of_domains` |
| `verify_ssl` | boolean | `true` |  |
| `proxy_url` | string |  | `Proxy_url` |
| `external_id` | string |  | `External_id` |
| `policy` | text |  | `Policy` |
| `role_arn` | string |  | `Role_arn` |
| `token_duration` | integer | `3600` (code) | `Token_duration` |

### Inputs

- `Aws_key` (`string`, required)
- `Aws_secret` (`string`, required)
- `Aws_region` (`string`, required)
- `Proxy_url` (`string`, optional)
- `External_id` (`string`, optional)
- `Policy` (`string`, optional)
- `Role_arn` (`string`, optional)
- `Token_duration` (`int`, optional)
- `Domain_name` (`string`, required)
- `Max_number_of_domains` (`int`, optional)
- `Next_token` (`string`, optional)
- `Item_name` (`string`, required)
- `Select_expression` (`string`, required)
- `Consistent_read` (`flag`, optional)
- `Attributes_put_list` (`array`)
- `attributes_list` (`array`)
- `Items_put_list` (`array`)
- `Items_delete_list` (`array`)
- `Attributes_names_list` (`array`)
- `Aws_session_token` (`pwd`)

### Outputs

- `Error_Message` (`string`)
- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Result` (`hash`)
- `Domain_List` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## AmazonSnsOperation

- **Display name**: Amazon SNS Operation
- **Category**: Integration
- **Version**: 0.4.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to use Amazon SNS service.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  | `Operation` |
| `aws_key` | string |  | `Aws_key` |
| `aws_secret` | string |  | `Aws_secret` |
| `aws_region` | string |  | `Aws_region` |
| `message` | string |  | `Message` |
| `subject` | string |  |  |
| `is_structure_json` | boolean |  | `Is_structure_json` |
| `target_arn` | string |  | `Target_arn` |
| `phone_number` | string |  | `Phone_number` |
| `topic_arn` | string |  | `Topic_arn` |
| `protocol` | string |  | `Protocol` |
| `endpoint` | string |  | `Endpoint` |
| `subscription_arn` | string |  | `Subscription_arn` |
| `verify_ssl` | boolean | `true` |  |
| `proxy_url` | string |  | `Proxy_url` |
| `external_id` | string |  | `External_id` |
| `policy` | text |  | `Policy` |
| `role_arn` | string |  | `Role_arn` |
| `token_duration` | integer | `3600` (code) | `Token_duration` |

### Inputs

- `Aws_key` (`string`, required)
- `Aws_secret` (`string`, required)
- `Aws_region` (`string`, required)
- `Operation` (`string`, required)
- `Proxy_url` (`string`, optional)
- `External_id` (`string`, optional)
- `Policy` (`string`, optional)
- `Role_arn` (`string`, optional)
- `Token_duration` (`int`, optional)
- `Topic_arn` (`string`, required)
- `Target_arn` (`string`, required)
- `Phone_number` (`string`, required)
- `Message` (`string`, required)
- `Is_structure_json` (`flag`, required)
- `Protocol` (`string`, required)
- `Endpoint` (`string`, required)
- `Subscription_arn` (`string`, required)
- `Aws_session_token` (`pwd`)

### Outputs

- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Error_Message` (`string`)
- `Message ID` (`string`)
- `SubscriptionARN` (`string`)
- `Successful?` (`flag`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## AmazonSqsOperation

- **Display name**: Amazon SQS Operation
- **Category**: Integration
- **Version**: 0.5.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to perform an action onto an Amazon SQS queue.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `aws_key` | string |  | `Aws_key` |
| `aws_secret` | string |  | `Aws_secret` |
| `aws_region` | string |  | `Aws_region` |
| `attribute_name` | string |  |  |
| `attribute_value` | string |  |  |
| `max_number_of_messages` | integer | `1` (code) | `Max_number_of_messages` |
| `receipt_handle` | text |  | `Receipt_handle` |
| `message_body` | text |  | `Message_body` |
| `queue_name` | string |  |  |
| `queue_url` | string |  | `Queue_url` |
| `verify_ssl` | boolean | `true` |  |
| `message_group_id` | string |  | `Message_group_id` |
| `message_deduplication_id` | string |  | `Message_deduplication_id` |
| `proxy_url` | string |  | `Proxy_url` |
| `external_id` | string |  | `External_id` |
| `policy` | text |  | `Policy` |
| `role_arn` | string |  | `Role_arn` |
| `token_duration` | integer | `3600` (code) | `Token_duration` |

### Inputs

- `Aws_key` (`string`, required)
- `Aws_secret` (`string`, required)
- `Aws_region` (`string`, optional)
- `Proxy_url` (`string`, optional)
- `External_id` (`string`, optional)
- `Policy` (`string`, optional)
- `Role_arn` (`string`, optional)
- `Token_duration` (`int`, optional)
- `Queue_url` (`string`, required)
- `Receipt_handle` (`string`, required)
- `Max_number_of_messages` (`int`, optional)
- `Message_body` (`string`, required)
- `Message_group_id` (`string`, optional)
- `Message_deduplication_id` (`string`, optional)
- `Aws_session_token` (`pwd`)

### Outputs

- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Response` (`hash`)
- `Messages` (`array`)
- `Messages_body` (`array`)
- `Error_message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AmazonSqsTrigger

- **Display name**: Amazon SQS trigger
- **Category**: Triggers
- **Version**: 0.4.4 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to watch for messages out of an Amazon SQS queue.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `aws_key` | string |  | `Aws_key` |
| `aws_secret` | string |  | `Aws_secret` |
| `aws_region` | string |  | `Aws_region` |
| `max_number_of_messages` | integer | `1` (code) | `Max_number_of_messages` |
| `queue_url` | string |  | `Queue_url` |
| `verify_ssl` | boolean |  |  |
| `keep_ongoing` | boolean |  |  |
| `polling_frequency` | integer | `5` (code) | `Polling_frequency` |
| `wait_time_seconds` | integer | `0` (code) | `Wait_time_seconds` |
| `proxy_url` | string |  | `Proxy_url` |
| `external_id` | string |  | `External_id` |
| `policy` | text |  | `Policy` |
| `role_arn` | string |  | `Role_arn` |
| `token_duration` | integer | `3600` (code) | `Token_duration` |

### Inputs

- `Aws_key` (`string`, required)
- `Aws_secret` (`string`, required)
- `Aws_region` (`string`, required)
- `Queue_url` (`string`, required)
- `Max_number_of_messages` (`int`, optional)
- `Wait_time_seconds` (`int`, optional)
- `Proxy_url` (`string`, optional)
- `Polling_frequency` (`int`, optional)
- `External_id` (`string`, optional)
- `Policy` (`string`, optional)
- `Role_arn` (`string`, optional)
- `Token_duration` (`int`, optional)
- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Response` (`hash`)
- `Messages_body` (`array`)
- `Error_Message` (`string`)
- `Aws_session_token` (`pwd`)

### Outputs

- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Response` (`hash`)
- `Messages_body` (`array`)
- `Error_Message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AmazonSwfOperation

- **Display name**: Amazon SWF Operation
- **Category**: Integration
- **Version**: 0.4.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to execute Amazon Simple Workflow API calls

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `aws_key` | string |  | `Aws_key` |
| `aws_secret` | string |  | `Aws_secret` |
| `aws_region` | string |  | `Aws_region` |
| `domain` | string |  | `Domain` |
| `swf_workflow_id` | string |  | `Swf_workflow_id` |
| `workflow_type_name` | string |  | `Workflow_type_name` |
| `workflow_type_version` | string |  | `Workflow_type_version` |
| `task_list` | string |  | `Task_list` |
| `task_priority` | integer |  | `Task_priority` |
| `execution_start_to_close_timeout` | integer |  | `Execution_start_to_close_timeout` |
| `task_start_to_close_timeout` | integer |  | `Task_start_to_close_timeout` |
| `swf_inputs` | text |  | `Swf_inputs` |
| `tag_list` | text | `` (code) | `Tag_list` |
| `child_policy` | string | `TERMINATE` (code) | `Child_policy` |
| `verify_ssl` | boolean | `true` |  |
| `proxy_url` | string |  | `Proxy_url` |
| `external_id` | string |  | `External_id` |
| `policy` | text |  | `Policy` |
| `role_arn` | string |  | `Role_arn` |
| `token_duration` | integer | `3600` (code) | `Token_duration` |

### Inputs

- `Aws_key` (`string`, required)
- `Aws_secret` (`string`, required)
- `Aws_region` (`string`, optional)
- `Proxy_url` (`string`, optional)
- `External_id` (`string`, optional)
- `Policy` (`string`, optional)
- `Role_arn` (`string`, optional)
- `Token_duration` (`int`, optional)
- `Domain` (`string`, required)
- `Swf_workflow_id` (`string`, required)
- `Workflow_type_name` (`string`, required)
- `Workflow_type_version` (`string`, required)
- `Task_list` (`string`, required)
- `Child_policy` (`string`, optional)
- `Tag_list` (`string`, optional)
- `Swf_inputs` (`string`, optional)
- `Task_priority` (`int`, optional)
- `Task_start_to_close_timeout` (`int`, optional)
- `Execution_start_to_close_timeout` (`int`, optional)
- `Aws_session_token` (`pwd`)

### Outputs

- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Response` (`string` or `hash`)
- `Run_Id` (`string`)
- `Error_Message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AmazonTranscribeOperation

- **Display name**: Amazon Transcribe Operation
- **Category**: Integration
- **Version**: 0.3.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to execute Amazon Transcribe API calls

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `aws_key` | string |  | `Aws_key` |
| `aws_secret` | string |  | `Aws_secret` |
| `aws_region` | string |  | `Aws_region` |
| `transcription_job_name` | string |  | `Transcription_job_name` |
| `lang_code` | string |  | `Lang_code` |
| `media_format` | string |  | `Media_format` |
| `polling_frequency` | string | `5` (code) |  |
| `sample_rate` | string |  |  |
| `file_uri` | string |  | `File_uri` |
| `output_bucket_name` | string |  |  |
| `vocab_name` | string |  |  |
| `show_speaker_labels` | boolean | `false` (code) |  |
| `max_speaker_labels` | string |  |  |
| `channel_id` | boolean | `false` (code) |  |
| `proxy_url` | string |  | `Proxy_url` |
| `external_id` | string |  | `External_id` |
| `policy` | text |  | `Policy` |
| `role_arn` | string |  | `Role_arn` |
| `token_duration` | integer | `3600` (code) | `Token_duration` |

### Inputs

- `Aws_key` (`string`, required)
- `Aws_secret` (`string`, required)
- `Aws_region` (`string`, optional)
- `Transcription_job_name` (`string`, required)
- `Lang_code` (`string`, required)
- `Media_format` (`string`, required)
- `File_uri` (`string`, required)
- `Proxy_url` (`string`, optional)
- `External_id` (`string`, optional)
- `Policy` (`string`, optional)
- `Role_arn` (`string`, optional)
- `Token_duration` (`int`, optional)
- `Aws_session_token` (`pwd`)

### Outputs

- `Temporary_access_key` (`string`)
- `Temporary_secret` (`string`)
- `Temporary_token` (`string`)
- `Response` (`hash`)
- `Error_Message` (`string`)
- `Step_information` (`hash`)

## AmberfinTranscoding

- **Display name**: Amberfin transcoding
- **Category**: Transcoding
- **Version**: 0.3.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This Action plug-in provides the ability to submit file transcoding job to a Amberfin server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server_node` | string |  | `Amberfin_server_node` |
| `server_address` | string |  | `Amberfin_server_address` |
| `api_port` | string | `8080` (code) | `Api_port` |
| `source_file` | string |  | `Source_file` |
| `target_dir` | string |  | `Target_dir` |
| `template` | string |  | `Template` |
| `polling_frequency` | integer | `5` (code) |  |
| `operation` | string | `Repurpose` (code) |  |
| `transcode_xml` | mediumtext |  | `Transcode_xml` |

### Inputs

- `Amberfin_server_address` (`string`, required)
- `Amberfin_server_node` (`string`, required)
- `Source_file` (`string`, required)
- `Template` (`string`, required)
- `Target_dir` (`string`, required)
- `Transcode_xml` (`string`, required)
- `Api_port` (`string`, optional)

### Outputs

- `Output_file` (`string`)
- `Errors` (`array`)
- `Job_Id` (`string`)
- `Input_file` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## AmqpMessage

- **Display name**: AMQP message
- **Category**: Integration
- **Version**: 0.9.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to insert messages into an AMQP queue.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `queue_name` | string |  | `AMQP_Queue_name` |
| `queue_host` | string |  | `Queue_host` |
| `queue_node` | string |  | `Queue_node` |
| `queue_port` | integer |  |  |
| `queue_user` | string |  | `Queue_user` |
| `queue_password` | string |  | `Queue_password` |
| `use_ssl` | boolean |  |  |
| `hide_message` | boolean |  |  |
| `message` | mediumtext |  | `Message` |
| `queue_vhost` | string |  | `Queue_vhost` |
| `fan_out` | boolean |  |  |
| `routing_key` | string |  | `Routing_key` |
| `exchange_name` | string |  | `Exchange_name` |
| `exchange_type` | string |  |  |
| `amqp_version_check` | boolean |  |  |
| `additional_queue_message_parameters` | boolean | `false` |  |
| `durable` | boolean | `true` |  |
| `auto_delete` | boolean |  |  |
| `exclusive` | boolean |  |  |
| `x_max_priority` | integer |  |  |
| `x_message_ttl` | integer |  |  |
| `x_expires` | integer |  |  |
| `persistent` | boolean | `true` |  |
| `mandatory` | boolean |  |  |
| `timestamp` | datetime |  |  |
| `expiration` | integer |  |  |
| `type` | string |  |  |
| `reply_to` | string |  |  |
| `content_type` | string |  |  |
| `content_encoding` | string |  |  |
| `correlation_id` | string |  |  |
| `priority` | integer |  |  |
| `message_id` | string |  |  |
| `user_id` | string |  |  |
| `app_id` | string |  |  |
| `header` | text |  | `Header` |
| `passive_flag` | boolean | `false` |  |
| `accept_multiple_messages` | boolean | `false` |  |

### Inputs

- `Queue_user` (`string`, optional)
- `Queue_password` (`string`, optional)
- `Routing_key` (`string`, optional)
- `Exchange_name` (`string`, optional)
- `AMQP_Queue_name` (`string`, required)
- `Message` (`string`, required)
- `Queue_node` (`string`, optional)
- `Queue_host` (`string`, optional)
- `Queue_vhost` (`string`, optional)
- `Header` (`string`, required)
- `Message_list` (`array`)
- `Queue_port` (`int`)
- `additional_queue_message_parameters` (`flag`)
- `durable` (`flag`)
- `auto_delete` (`flag`)
- `exclusive` (`flag`)
- `x_max_priority` (`int`)
- `x_message_ttl` (`int`)
- `x_expires` (`int`)
- `persistent` (`flag`)
- `mandatory` (`flag`)
- `timestamp` (`date`)
- `expiration` (`int`)
- `type` (`string`)
- `reply_to` (`string`)
- `content_type` (`string`)
- `content_encoding` (`string`)
- `correlation_id` (`string`)
- `priority` (`int`)
- `message_id` (`string`)
- `user_id` (`string`)
- `app_id` (`string`)
- `headers` (`hash`)

### Outputs

- `Queue_name` (`string`)
- `Inserted_messages` (`array`)
- `Inserted_message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AmqpTrigger

- **Display name**: AMQP trigger
- **Category**: Triggers
- **Version**: 0.9.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to wait for messages in an AMQP queue.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `keep_ongoing` | boolean |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `queue_name` | string |  | `Queue_name` |
| `queue_host` | string |  | `Queue_host` |
| `queue_node` | string |  | `Queue_node` |
| `queue_port` | integer |  |  |
| `queue_user` | string |  | `Queue_user` |
| `queue_password` | string |  | `Queue_password` |
| `use_ssl` | boolean |  |  |
| `message_postprocessing` | text |  |  |
| `formatted_outputs` | text |  |  |
| `queue_vhost` | string |  | `Queue_vhost` |
| `no_ack` | boolean |  |  |
| `routing_key` | string |  |  |
| `max_number_of_item_per_cycle` | integer | `1` (code) | `Max_number_of_item_per_cycle` |
| `amqp_version_check` | boolean |  |  |
| `connection_timeout` | integer | `1` (code) | `Connection_timeout` |
| `x_max_priority` | integer |  |  |
| `x_message_ttl` | integer |  |  |
| `x_expires` | integer |  |  |
| `not_durable` | boolean | `false` |  |

### Inputs

- `Queue_name` (`string`, required)
- `Queue_user` (`string`, optional)
- `Queue_password` (`string`, optional)
- `Max_number_of_item_per_cycle` (`int`, optional)
- `Connection_timeout` (`int`, optional)
- `Queue_node` (`string`, optional)
- `Queue_host` (`string`, optional)
- `Queue_vhost` (`string`, optional)
- `Queue_port` (`int`)
- `x_max_priority` (`int`)
- `x_message_ttl` (`int`)
- `x_expires` (`int`)
- `not_durable` (`flag`)
- `routing_key` (`string`)
- `ca_certificate_location` (`string`)
- `certificate_location` (`string`)
- `certificate_key` (`string`)
- `use_tls` (`flag`)
- `verify_peer` (`flag`)

### Outputs

- `Message_payload` (`string`)
- `Queue_name` (`string`)
- `Messages_left_count` (`int`)
- `Message_response` (`string`)
- `Message_headers` (`string`)
- `Message_payloads` (`array`)
- `Messages_responses` (`array`)
- `Messages_headers` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## ArchiveManager

- **Display name**: Archive manager
- **Category**: File Operations
- **Version**: 0.4.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in can be used to manage a file archive, by deleting or compressing aging entries.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `archive_root` | string |  | `Archive_root` |
| `purge_file_pattern` | string | `[^/]+` (code) |  |
| `kept_duration_unit` | string | `days` (code) |  |
| `kept_duration` | integer |  | `Kept_duration` |
| `manifest_dir` | string | `` (code) | `Manifest_directory` |
| `delete_empty_folders` | boolean |  |  |
| `compress` | boolean |  |  |
| `compress_as` | string | `archive` (code) |  |
| `manifest_retention_duration` | integer |  |  |
| `manifest_retention_unit` | string |  |  |
| `compression_format` | string | `zip` (code) |  |
| `extended_matching` | boolean |  |  |
| `use_mtime` | boolean |  |  |
| `do_not_delete` | boolean | `false` (code) | `Do_not_delete` |

### Inputs

- `Archive_root` (`string`, required)
- `Kept_duration` (`int`, required)
- `Manifest_directory` (`string`, optional)
- `Do_not_delete` (`flag`, optional)
- `Purge_file_pattern` (`string`)
- `Compressed_name` (`string`)
- `Kept_duration_unit` (`string`)

### Outputs

- `Files_purged` (`array`)
- `Purge_manifest` (`string`)
- `Step_information` (`hash`)

## ArrayFanout

- **Display name**: Array fan-out
- **Category**: System
- **Version**: 1.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin executes the following workflow step once for each element in an input array, enabling parallel or serial processing of array data with customizable variable exposure and step labeling for efficient batch operations.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `variable_type` | string |  |  |
| `comments` | text |  |  |
| `serialize` | boolean | `false` (code) |  |
| `step_label` | string |  |  |
| `fanned_as` | string |  |  |
| `fanout_variable` | string |  |  |

### Inputs

- `<fanout_variable>` (`array`)

### Outputs

- `<fanned_as>` (`<variable_type>`)
- `Fanout_Size` (`int`)
- `Step_information` (`hash`)

### Notes

- A name in angle brackets (`<attribute>`) is the value of that template attribute.
- Outputs are partly defined by template fields: see the template attributes.

## AscpClient

- **Display name**: Ascp client
- **Category**: File Transfer
- **Version**: 1.6.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin performs a file transfer upload or download operation to/from a server using Aspera's FASP protocol. In order for it to work, an Aspera client or server product needs to be installed on the Orchestrator server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `files_array` | text |  |  |
| `host` | string |  | `Remote_host` |
| `remote_node` | string |  | `Remote_node` |
| `remote_node_user` | string |  | `Remote_user` |
| `remote_node_passwd` | string |  | `Remote_user_password` |
| `ssh_port_int` | string | `0` (code) | `SSH_port` |
| `destination_path` | string |  |  |
| `target_rate` | string | `30m` (code) |  |
| `command_line_options` | text | `-Q` (code) |  |
| `management_port_base` | integer | `49152` (code) |  |
| `management_port_range` | integer | `16000` (code) |  |
| `file_list_option` | boolean | `false` |  |
| `disable_management_port_connection` | boolean | `false` |  |
| `token` | string |  | `Token` |
| `use_token_authentication` | boolean | `false` |  |
| `cookie` | string |  |  |

### Inputs

- `Remote_host` (`string`, required)
- `Remote_user` (`string`, required)
- `SSH_port` (`int`, optional)
- `Token` (`string`, required)
- `Remote_user_password` (`string`, required)
- `Remote_node` (`string`, optional)

### Outputs

- `Session ID` (`string`)
- `Transferred files` (`array`)
- `Transferred bytes` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## AsperaCentralWatcher

- **Display name**: Aspera central watcher
- **Category**: Triggers
- **Version**: 2.8.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides the ability to sense the initiation or completion of transfers on an Aspera server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `service_uri` | string |  |  |
| `allow_multiple` | boolean |  |  |
| `transfer_direction` | string |  |  |
| `transfer_server_address` | string |  |  |
| `transfer_client_address` | string |  |  |
| `session_status` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `report_empty` | boolean |  |  |
| `user_list_filter` | string |  | `User_list_filter` |
| `file_regexp_filter` | string |  | `File_regexp_filter` |
| `central_node` | string |  |  |
| `service_address` | string |  |  |
| `trigger_type` | string |  |  |
| `trigger_operation` | string |  |  |
| `trigger_on_empty_file` | boolean | `false` |  |
| `trigger_on_zero_byte_transfers` | boolean | `false` |  |
| `node_user` | string |  | `Node_user` |
| `node_password` | string |  | `Node_password` |
| `session_file_filter` | string |  |  |
| `file_transfer_status` | string |  |  |
| `cookie_filter` | string |  | `Cookie pattern` |

### Inputs

- `File_regexp_filter` (`string`, optional)
- `User_list_filter` (`string`, optional)
- `Cookie pattern` (`string`, optional)
- `Node_user` (`string`, optional)
- `Node_password` (`string`, optional)
- `monitored_node` (`string`)
- `Central_node` (`string`)
- `service_URI` (`string`)
- `keep_ongoing` (`flag`)
- `trigger_on_empty_file` (`flag`)
- `trigger_on_zero_byte_transfers` (`flag`)
- `transfer_direction` (`string`)
- `transfer_server_address` (`string`)
- `transfer_client_address` (`string`)
- `session_status` (`string`)
- `file_transfer_status` (`string`)

### Outputs

- `session_id` (`string`)
- `file_status` (`string`)
- `user` (`string` or `array`)
- `file_name` (`string`)
- `file_size` (`string`)
- `file_transfer_start_date` (`string`)
- `file_transfer_end_date` (`string`)
- `files_failed` (`array` or `int`)
- `file_list` (`array`)
- `files_information` (`hash`)
- `direction` (`string`)
- `file_count` (`int`)
- `file_sizes_list` (`hash`)
- `source_files_list` (`array`)
- `session_status` (`string`)
- `remote_address` (`string`)
- `expected_byte_count` (`int`)
- `expected_file_count` (`int`)
- `actual_bytes_transferred` (`int`)
- `error_code` (`int`)
- `error_message` (`string`)
- `files_md5` (`hash`)
- `files_status` (`hash`)
- `FASP_cookie` (`string`)
- `start_time` (`date`)
- `end_time` (`date`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AsperaFilesPackageDelivery

- **Display name**: AoC Package Delivery
- **Category**: File Transfer
- **Version**: 0.5.1 (requires Orchestrator 4.1.6 or later)
- **Description**: A plugin to create and deliver file packages to recipients in Aspera on Cloud.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `files_client_id` | string |  | `Files_client_id` |
| `files_client_secret` | string |  | `Files_client_secret` |
| `files_scope` | string |  | `Files_scope` |
| `files_user_name` | string |  | `Files_user_name` |
| `private_key_filepath` | string |  | `Private_key_filepath` |
| `files_organization_name` | string |  | `Files_organization_name` |
| `workspace_name` | string | `` (code) |  |
| `workspace_id` | string |  | `Workspace_id` |
| `package_name` | string |  | `Package_name` |
| `package_note` | string | `` (code) | `Package_note` |
| `recipient_data` | text |  | `Recipient_data` |
| `package_metadata` | text | `` (code) | `Package_metadata` |
| `custom_package_payload` | text | `` (code) |  |
| `package_operation` | string |  |  |
| `transferred_file_sessions_count` | integer | `1` (code) | `Transferred_file_sessions_count` |
| `files_package_id` | string |  | `Files_package_id` |
| `return_transfer_node_informations` | boolean |  |  |
| `encryption_at_rest` | boolean |  |  |
| `http_proxy` | string |  | `Http_proxy` |
| `download_notification_list` | string |  | `Download_notification_list` |

### Inputs

- `Files_client_id` (`string`, required)
- `Files_client_secret` (`string`, required)
- `Files_scope` (`string`, required)
- `Files_user_name` (`string`, required)
- `Files_organization_name` (`string`, required)
- `Private_key_filepath` (`string`, required)
- `Http_proxy` (`string`, optional)
- `Download_notification_list` (`string`, optional)
- `Transferred_file_sessions_count` (`int`, optional)
- `Files_package_id` (`string`, required)
- `Package_name` (`string`, required)
- `Package_note` (`string`, optional)
- `Workspace_id` (`string`, required)
- `Package_metadata` (`string`, optional)
- `Recipient_data` (`string`, required)
- `workspace_id` (`string`)
- `workspace_name` (`string`)

### Outputs

- `HTTP_Return_Code_Token_Call` (`int`)
- `HTTP_Return_Code_Package_Call` (`int`)
- `Files_OAuth_Token` (`string`)
- `Files_Package_ID` (`string`)
- `Contents_File_ID` (`string`)
- `File_ID` (`string`)
- `Package_Metadata` (`hash`)
- `Sender_Email` (`string`)
- `Sender_Name` (`string`)
- `Recipient_Email` (`string`)
- `Recipient_Name` (`string`)
- `Recipient_Type` (`string`)
- `Access_Key` (`string`)
- `Host` (`string`)
- `Node_ID` (`string`)
- `Access_Token` (`string`)
- `Tags` (`string`)
- `workspace_id` (`string`)
- `workspace_name` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AsperaFilesPackageWatcher

- **Display name**: AoC Package Watcher
- **Category**: Triggers
- **Version**: 0.6.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin can be used to trigger workflows on new packages uploaded to Aspera On Cloud.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `files_client_id` | string |  | `Files_client_id` |
| `files_client_secret` | string |  | `Files_client_secret` |
| `files_scope` | string |  | `Files_scope` |
| `files_user_name` | string |  | `Files_user_name` |
| `private_key_filepath` | string |  | `Private_key_filepath` |
| `files_organization_name` | string |  | `Files_organization_name` |
| `package_operation` | string |  |  |
| `files_package_id` | string |  | `Files_package_id` |
| `keep_ongoing` | boolean |  |  |
| `polling_frequency` | integer | `10` (code) | `Polling_frequency` |
| `trigger_type` | string | `` (code) | `Trigger_type` |
| `ignore_existing_packages` | boolean |  |  |
| `filters_code` | text | `` (code) | `Filters_code` |
| `extract_file_info` | boolean | `true` | `Extract_file_info` |
| `node_access_key` | string |  | `Node_access_key` |
| `node_secret` | string |  | `Node_secret` |
| `files_packages_folder_path` | string |  | `Files_packages_folder_path` |
| `last_timestamp` | string |  |  |
| `token` | text |  |  |
| `token_expiration` | datetime |  |  |
| `http_proxy` | text |  | `Http_proxy` |

### Inputs

- `Files_client_id` (`string`, required)
- `Files_client_secret` (`string`, required)
- `Files_scope` (`string`, required)
- `Files_user_name` (`string`, required)
- `Files_organization_name` (`string`, required)
- `Private_key_filepath` (`string`, required)
- `Node_access_key` (`string`, optional)
- `Node_secret` (`string`, optional)
- `Http_proxy` (`string`, optional)
- `Files_package_id` (`string`, required)
- `Polling_frequency` (`int`, optional)
- `Trigger_type` (`string`, optional)
- `Filters_code` (`string`, optional)
- `Extract_file_info` (`flag`, optional)
- `Files_packages_folder_path` (`string`, optional)
- `Authorization` (`<token>`)
- `Token` (`<token>`)

### Outputs

- `HTTP_Return_Code_Token_Call` (`int`)
- `Files_OAuth_Token` (`string`)
- `Files_Package_Name` (`string`)
- `Files_Package_Note` (`string`)
- `Authorization` (`<token>`)
- `Files_Package_ID` (`string`)
- `Contents_File_ID` (`string`)
- `File_ID` (`string`)
- `Package_Metadata` (`array`)
- `Metadata_Hash` (`hash`)
- `Sender_Email` (`string`)
- `Sender_Name` (`string`)
- `External_Sender` (`flag`)
- `Recipient_Email` (`string`)
- `Recipient_Name` (`string`)
- `Recipient_Type` (`string`)
- `Token` (`string` or `<token>`)
- `Node_API_Header` (`hash`)
- `Package_Hash` (`hash`)
- `Workspace_Name` (`string`)
- `Package_File_Paths_On_Node` (`array`)
- `File_Names` (`array`)
- `Files_Hash` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- A name in angle brackets (`<attribute>`) is the value of that template attribute.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## AsperaNodeApi

- **Display name**: Aspera Node API
- **Category**: File Operations
- **Version**: 0.2.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to perform file system operations such as search, rename, and delete. It also supports retrieving node information (e.g., token, SSH user, and port) and checking node availability through status queries (ping).

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server_node` | string |  |  |
| `server_address` | string |  |  |
| `node_api_port` | integer | `9091` (code) |  |
| `operation` | string |  |  |
| `use_ssl` | boolean | `false` (code) |  |
| `node_user_name` | string |  |  |
| `node_password` | string |  |  |
| `source` | string |  | `Source_File_Path` |
| `target` | string |  | `Target_File_Path` |
| `force_rename` | boolean |  |  |
| `max_count` | string | `1000000` (code) |  |
| `filter_file_type` | string |  |  |
| `filter_name` | string |  |  |
| `filter_basename` | string |  |  |
| `filter_size_min` | string |  |  |
| `filter_size_max` | string |  |  |
| `filter_mtime_min` | string |  |  |
| `filter_mtime_max` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |

### Inputs

- `Source_File_Path` (`string`, required)
- `Target_File_Path` (`string`, required)
- `Aspera_Node_Server_Address` (`string`)
- `AsperaNodeUser` (`string`)
- `AsperaNodeUserPassword` (`string`)
- `use_ssl` (`string`)
- `filter_file_type` (`string`)
- `filter_basename` (`string`)
- `max_count` (`string`)
- `filter_size_min` (`string`)
- `filter_size_max` (`string`)
- `filter_mtime_min` (`string`)
- `filter_mtime_max` (`string`)

### Outputs

- `NODE_API_RESULTS` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## AsperaNodeApiTransferMonitor

- **Display name**: Aspera Node API Transfer Monitor
- **Category**: Triggers
- **Version**: 0.3.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to monitor and detect file transfer events on remote Aspera servers via the Aspera Node API.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `auth_type` | string | `BASIC_AUTH` (code) | `Auth_type` |
| `remote_node` | string |  | `remote_node` |
| `service_node_ip` | string |  | `Service_node_ip` |
| `service_node_port` | string |  | `Service_node_port` |
| `user_login` | string |  | `User_login` |
| `user_password` | string |  | `User_password` |
| `count` | integer | `1` (code) | `Count` |
| `after_time` | datetime |  |  |
| `type_glob` | string |  | `Type_glob` |
| `keep_ongoing` | boolean |  |  |
| `polling_frequency` | integer | `10` (code) |  |
| `use_ssl` | boolean | `false` (code) | `use_ssl` |
| `trigger_type` | string | `TRIG_GROUP` (code) |  |
| `filter_direction` | string |  | `Filter_direction` |
| `filter_file_path` | string |  | `Filter_file_path` |
| `ignore_zero_byte_transfers` | boolean | `false` (code) | `Ignore_zero_byte_transfers` |
| `ignore_empty_transfers` | boolean | `false` (code) | `Ignore_empty_transfers` |
| `transfer_type` | string |  | `Transfer_type` |
| `tag_filter` | string |  | `Tag_filter` |
| `transfer_id` | string |  | `Transfer_id` |
| `return_single` | boolean | `false` |  |

### Inputs

- `Filter_direction` (`string`, optional)
- `Filter_file_path` (`string`, optional)
- `Ignore_zero_byte_transfers` (`flag`, optional)
- `Ignore_empty_transfers` (`flag`, optional)
- `Transfer_type` (`string`, optional)
- `Type_glob` (`string`, optional)
- `Count` (`int`, optional)
- `Tag_filter` (`string`, optional)
- `Transfer_id` (`string`, optional)
- `Service_node_ip` (`string`, required)
- `use_ssl` (`flag`, optional)
- `Auth_type` (`string`, optional)
- `Service_node_port` (`string`, required)
- `User_login` (`string`, required)
- `User_password` (`string`, required)
- `remote_node` (`string`, required)
- `File_list` (`array`)
- `Error` (`string`)
- `File_List_With_Details` (`hash` or `array`)
- `Transfer_id_list` (`string` or `array`)

### Outputs

- `File_list` (`array`)
- `Error` (`string`)
- `File_List_With_Details` (`hash` or `array`)
- `Transfer_id_list` (`string` or `array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AsperaNodeApiTransferOperation

- **Display name**: Aspera Node API Transfer
- **Category**: File Transfer
- **Version**: 1.3.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides the ability to initiate and monitor server-to-server transfers using Aspera's Node API cluster protocol.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `payload` | text |  | `Payload` |
| `remote_node` | string |  | `Remote_node` |
| `service_node_ip` | string |  | `Service_node_ip` |
| `service_node_port` | string |  | `Service_node_port` |
| `user_login` | string |  | `User_login` |
| `user_password` | string |  | `User_password` |
| `operation` | string |  | `Operation` |
| `direction` | string |  | `Direction` |
| `remote_host` | string |  | `Remote_host` |
| `remote_access_key` | string |  | `Remote_access_key` |
| `source_root_id` | string |  | `Source_root_id` |
| `destination_root_id` | string |  | `Destination_root_id` |
| `target_rate_kbps` | integer |  | `Target_rate_kbps` |
| `fasp_port` | integer | `33001` (code) | `Fasp_port` |
| `ssh_port` | integer | `33001` (code) | `Ssh_port` |
| `remote_user` | string |  | `Remote_user` |
| `multi_session` | integer | `1` (code) | `Multi_session` |
| `delete_source` | boolean | `false` (code) | `Delete_source` |
| `destination_root` | string | `/` (code) | `Destination_root` |
| `source` | string |  | `Source` |
| `create_dir` | boolean | `false` (code) | `Create_dir` |
| `use_ssl` | boolean |  | `Use_ssl` |
| `polling_frequency` | integer | `5` (code) |  |
| `remote_token` | string |  | `Remote_token` |
| `job_id` | string |  | `Job_id` |
| `remote_secret_key` | string |  | `Remote_secret_key` |
| `remote_password` | string |  | `Remote_password` |
| `remote_key_path` | string |  | `Remote_key_path` |
| `remote_private_key_passphrase` | string |  | `Remote_private_key_passphrase` |
| `auth_type` | string |  |  |
| `have_token` | boolean | `true` |  |
| `response_output` | boolean | `true` |  |
| `rate_policy` | string | `fair` | `Rate_policy` |
| `crypt_op` | string | `none` (code) | `EAR operation` |
| `passphrase` | string | `` (code) | `EAR passphrase` |
| `proxy` | string | `` (code) | `Proxy` |
| `httpproxy` | string | `` (code) | `Httpproxy` |
| `verbose` | boolean | `false` |  |
| `src_base` | string | `` (code) | `Src_base` |
| `path_separator_char` | string | `,` (code) |  |

### Inputs

- `Service_node_ip` (`string`, required)
- `Use_ssl` (`flag`, required)
- `Operation` (`string`, required)
- `Service_node_port` (`string`, optional)
- `User_login` (`string`, required)
- `User_password` (`string`, required)
- `Proxy` (`string`, optional)
- `Httpproxy` (`string`, optional)
- `Remote_node` (`string`, required)
- `Payload` (`string`, required)
- `Job_id` (`string`, required)
- `Remote_token` (`string`, required)
- `Remote_access_key` (`string`, required)
- `Remote_secret_key` (`string`, required)
- `Remote_user` (`string`, required)
- `Remote_password` (`string`, required)
- `Remote_private_key_passphrase` (`string`, optional)
- `Remote_key_path` (`string`, required)
- `Direction` (`string`, required)
- `Remote_host` (`string`, required)
- `Multi_session` (`int`, optional)
- `Create_dir` (`flag`, optional)
- `Delete_source` (`flag`, optional)
- `Source` (`string`, required)
- `Destination_root` (`string`, optional)
- `Source_root_id` (`string`, optional)
- `Destination_root_id` (`string`, optional)
- `Target_rate_kbps` (`int`, optional)
- `Fasp_port` (`int`, optional)
- `Ssh_port` (`int`, optional)
- `Rate_policy` (`string`, optional)
- `EAR operation` (`string`, optional)
- `EAR passphrase` (`string`, optional)
- `Src_base` (`string`, optional)
- `Job_ID` (`string`)
- `Transfer_Upload_Response_Received` (`hash`)
- `Error_Code` (`int`)
- `Error_Description` (`string`)
- `Transferred file count` (`string`)
- `Transferred File list` (`array`)
- `Failed File list` (`array`)
- `source` (`<source>`)
- `remote_user` (`string`)
- `Job_Status_Response_Received` (`hash`)

### Outputs

- `Job_ID` (`string`)
- `Transfer_Upload_Response_Received` (`hash`)
- `Error_Code` (`int`)
- `Error_Description` (`string`)
- `Transferred file count` (`string`)
- `Transferred File list` (`array`)
- `Failed File list` (`array`)
- `source` (`<source>`)
- `Job_Status_Response_Received` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- A name in angle brackets (`<attribute>`) is the value of that template attribute.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AsperaNodeFileWatcher

- **Display name**: Aspera node file watcher
- **Category**: Triggers
- **Version**: 0.9.5 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to detect and monitor files and folders matching specified patterns on remote Aspera servers via the Aspera Node API.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `watch_directory` | string |  | `Watch_directory` |
| `file_pattern` | string |  | `File_pattern` |
| `remote_node` | string |  |  |
| `server_address` | string |  |  |
| `node_api_port` | integer |  |  |
| `node_user_name` | string |  |  |
| `node_password` | string |  |  |
| `use_ssl` | boolean | `false` (code) |  |
| `depth_max` | string |  |  |
| `ignore_folders` | boolean |  |  |
| `polling_frequency` | integer | `10` (code) |  |
| `check_once` | boolean |  |  |
| `keep_ongoing` | boolean |  |  |
| `return_single` | boolean |  |  |
| `trigger_on_partial` | boolean |  |  |
| `trigger_type` | string | `TRIG_GROUP` (code) |  |
| `rest_timeout` | integer | `60` (code) |  |
| `exclusions` | string |  | `Exclusions` |
| `ignore_zero_bytes` | boolean | `false` | `Ignore_zero_bytes` |
| `aggressive_pruning` | boolean | `false` |  |
| `beacon_file_path` | string |  |  |
| `return_only_folder` | boolean | `false` |  |
| `ignore_badgateway_error` | boolean | `false` |  |
| `count` | integer | `1000` (code) | `Count` |
| `use_page` | boolean |  |  |
| `date_descending` | boolean |  |  |
| `random_selection` | boolean |  |  |

### Inputs

- `File_pattern` (`string`, required)
- `Watch_directory` (`string`, required)
- `Exclusions` (`string`, optional)
- `Ignore_zero_bytes` (`flag`, optional)
- `Count` (`int`, optional)
- `File_list` (`array`)
- `File_path` (`string`)
- `node_user_name` (`string`)
- `node_password` (`string`)
- `server_address` (`string`)
- `use_ssl` (`flag`)
- `Node_API_port` (`int`)

### Outputs

- `File_list` (`array`)
- `File_path` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AsperaNodeSearch

- **Display name**: Aspera Node Search
- **Category**: File Operations
- **Version**: 0.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to perform file system operations (search, rename, delete) through the Aspera Node API.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server_node` | string |  |  |
| `server_address` | string |  |  |
| `node_api_port` | integer |  |  |
| `use_ssl` | boolean | `false` (code) |  |
| `node_user_name` | string |  |  |
| `node_password` | string |  |  |
| `search_root` | string | `/` (code) | `Search_root` |
| `max_count` | string | `1000000` (code) |  |
| `filter_file_type` | string |  |  |
| `filter_name` | string |  |  |
| `filter_basename` | string |  |  |
| `filter_size_min` | string |  |  |
| `filter_size_max` | string |  |  |
| `filter_mtime_min` | string |  |  |
| `filter_mtime_max` | string |  |  |
| `max_depth` | integer | `0` (code) |  |

### Inputs

- `Search_root` (`string`, optional)
- `Aspera_Node_Server_Address` (`string`)
- `AsperaNodeUser` (`string`)
- `AsperaNodeUserPassword` (`string`)
- `Use_ssl` (`flag`)
- `Filter_file_type` (`string`)
- `Filter_name` (`string`)
- `Filter_basename` (`string`)
- `max_count` (`int`)
- `max_depth` (`int`)
- `Filter_size_min` (`int`)
- `Filter_size_max` (`int`)
- `Filter_mtime_min` (`date`)
- `Filter_mtime_max` (`date`)
- `Node_API_port` (`int`)

### Outputs

- `Search Results` (`array`)
- `Item Count` (`int`)
- `Total Count` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## AsperaOnCloudManagement

- **Display name**: Aspera On Cloud Management
- **Category**: Integration
- **Version**: 0.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: A plugin to perform Aspera On Cloud management operations including shared inbox and user account management.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `aoc_client_id` | string |  | `Aoc_client_id` |
| `aoc_client_secret` | string |  | `Aoc_client_secret` |
| `aoc_user_name` | string |  | `Aoc_user_name` |
| `private_key_filepath` | string |  | `Private_key_filepath` |
| `aoc_organization_name` | string |  | `Aoc_organization_name` |
| `operation` | string |  |  |
| `workspace_name` | string |  | `Workspace name` |
| `dropbox_name` | string |  | `Shared inbox name` |
| `member_list` | string |  | `Member list` |
| `metadata` | text |  | `Metadata` |
| `email_address` | string |  | `Email_address` |
| `first_name` | string |  | `First_name` |
| `last_name` | string |  | `Last_name` |
| `user_type` | string |  |  |
| `shared_inbox_description` | string |  | `Shared_inbox_description` |
| `http_proxy` | string |  | `Http_proxy` |

### Inputs

- `Aoc_client_id` (`string`, required)
- `Aoc_client_secret` (`string`, required)
- `Aoc_user_name` (`string`, required)
- `Aoc_organization_name` (`string`, required)
- `Private_key_filepath` (`string`, required)
- `Http_proxy` (`string`, optional)
- `Shared inbox name` (`string`, required)
- `Workspace name` (`string`, required)
- `Member list` (`string`, optional)
- `Metadata` (`string`, optional)
- `Shared_inbox_description` (`string`, optional)
- `Email_address` (`string`, required)
- `First_name` (`string`, required)
- `Last_name` (`string`, required)
- `User type` (`string`)

### Outputs

- `result` (`string`)
- `result_json` (`string`)
- `HTTP_return_code` (`int`)
- `Workspace name` (`string`)
- `User type` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AsperaOtfv

- **Display name**: Aspera Out-of-Transfer File Validation
- **Category**: File Transfer
- **Version**: 0.1.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides the ability to retrieve the list of files to validate and update the file status during validation.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `node_ip_address` | string |  |  |
| `remote_node` | string |  |  |
| `use_remote_node` | boolean | `false` |  |
| `use_ssl` | boolean | `true` |  |
| `node_port` | integer |  |  |
| `node_user` | string |  |  |
| `node_password` | string |  |  |
| `validator_id` | string | `orchestrator` (code) |  |
| `operation` | string |  |  |
| `session_uuid` | string |  |  |
| `file_id` | string |  |  |
| `file_status` | string |  |  |
| `bytes_processed` | integer | `0` (code) |  |
| `error_code` | integer | `1` (code) |  |
| `error_description` | string | `error` (code) |  |
| `max_result` | integer | `20` (code) |  |
| `keep_ongoing` | boolean | `true` |  |
| `polling_frequency` | integer | `10` (code) |  |

### Inputs

- `file_status` (`string`)

### Outputs

- `result_count` (`int`)
- `file_transfer_info` (`array`)
- `file_status` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AsperaSharesManagement

- **Display name**: Aspera Shares Management
- **Category**: Other Utilities
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin is used to utilize Aspera Shares command line utilities to perform shares management tasks such as creating, modifying, and administering shared directories on Aspera Shares servers.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `os_type` | string |  | `Os_type` |
| `shares_version` | string |  | `Shares_version` |
| `operation_type` | string |  | `Operation_type` |
| `execution_node` | string |  | `Execution_node` |
| `shares_user_name` | string |  | `Shares_user_name` |
| `shares_password` | string |  | `Shares_password` |
| `email_id` | string |  | `Email_id` |
| `first_name` | string | `` (code) | `First_name` |
| `last_name` | string | `` (code) | `Last_name` |
| `group_name` | string |  | `Group_name` |
| `node_name` | string |  | `Node_name` |
| `share_name` | string |  | `Share_name` |
| `directory` | string |  | `Directory` |

### Inputs

- `Os_type` (`string`, required)
- `Shares_version` (`string`, required)
- `Operation_type` (`string`, required)
- `Execution_node` (`string`, required)
- `Shares_user_name` (`string`, required)
- `Shares_password` (`string`, required)
- `Email_id` (`string`, required)
- `First_name` (`string`, optional)
- `Last_name` (`string`, optional)
- `Group_name` (`string`, required)
- `Share_name` (`string`, required)
- `Node_name` (`string`, required)
- `Directory` (`string`, required)

### Outputs

- `Error_Message` (`string`)
- `Login_Id` (`string`)
- `Group_Name` (`string`)
- `Share_Name` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AsyncRemoteExecution

- **Display name**: Async Remote Execution
- **Category**: Integration
- **Version**: 0.6.4 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin executes commands remotely on target servers via SSH with support for synchronous and asynchronous execution modes. It offers flexible authentication options, custom output processing, and configurable polling for background process monitoring.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `command` | text |  | `Command` |
| `remote_node` | string |  |  |
| `remote_address` | string |  |  |
| `remote_ssh_username` | string | `` (code) |  |
| `remote_ssh_password` | string | `` (code) |  |
| `remote_ssh_port` | string | `22` (code) |  |
| `remote_ssh_key` | string | `` (code) |  |
| `timeout` | integer | `60` (code) | `Timeout` |
| `keep_ongoing` | boolean | `false` (code) |  |
| `polling_command` | text | `` (code) | `Polling_command` |
| `polling_period` | integer | `10` (code) | `Polling_period` |
| `polling_stop_condition` | text | `` (code) | `Polling_stop_condition` |
| `processed_outputs` | text |  |  |
| `processed_outputs_code` | text | `` (code) | `Processed_outputs_code` |
| `environment_variables` | string |  |  |
| `connection_options` | string | `` (code) |  |
| `remote_ssh_key_passphrase` | string | `` (code) |  |
| `remote_ssh_key_data` | text | `` (code) |  |
| `shell` | string |  |  |

### Inputs

- `Command` (`string`, required)
- `Timeout` (`int`, optional)
- `Polling_command` (`string`, optional)
- `Polling_period` (`int`, optional)
- `Polling_stop_condition` (`string`, optional)
- `Processed_outputs_code` (`string`, optional)
- `remote_node` (`string`)
- `remote_address` (`string`)
- `remote_ssh_username` (`string`)
- `remote_ssh_password` (`string`)
- `remote_ssh_key` (`string`)
- `remote_ssh_key_data` (`string`)
- `remote_ssh_key_passphrase` (`string`)
- `remote_ssh_port` (`int`)

### Outputs

- `std_out` (`string`)
- `std_error` (`string`)
- `exit_code` (`int`)
- `PID` (`int`)
- `remote_node` (`string`)
- `remote_address` (`string`)
- `remote_ssh_username` (`string`)
- `remote_ssh_password` (`string`)
- `remote_ssh_key` (`string`)
- `remote_ssh_key_data` (`string`)
- `remote_ssh_key_passphrase` (`string`)
- `remote_ssh_port` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## AtemeTranscoding

- **Display name**: Ateme transcoding
- **Category**: Transcoding
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides the ability to transcode video files via Ateme Titan File. It implements the Ateme Titan 3.7 REST API 1.7.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `remote_node` | string |  |  |
| `server_address` | string |  |  |
| `polling_frequency` | integer | `10` (code) |  |
| `preset_name` | string |  | `preset_name` |
| `source` | string |  | `source` |
| `destination` | string |  | `destination` |
| `transcoding_payload` | text |  | `transcoding_payload` |

### Inputs

- `source` (`string`, required)
- `destination` (`string`, required)
- `transcoding_payload` (`string`, optional)
- `preset_name` (`string`, optional)
- `server address` (`string`)

### Outputs

- `XML_result` (`string`)
- `Ateme_status_code` (`string`)
- `Ateme_error_message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## AuroraFileVerification

- **Display name**: Aurora file verification
- **Category**: Quality Control
- **Version**: 1.4.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This Action plug-ins enables the submission of a file verification request to a Tektronix Aurora Server

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server_node` | string |  |  |
| `server_port` | string | `1002` (code) |  |
| `server_address` | string |  |  |
| `user` | string |  |  |
| `password` | string |  |  |
| `file_path` | string |  |  |
| `test_plan` | string |  |  |
| `report_folder` | string | `` (code) |  |
| `pass_on_warnings` | boolean |  |  |
| `stop_on_error` | boolean |  |  |
| `queue_on_top` | boolean | `false` (code) |  |
| `polling_frequency` | integer | `5` (code) |  |
| `do_not_alter_path` | boolean | `false` (code) |  |
| `return_xml_report` | boolean |  |  |
| `return_html_report` | boolean |  |  |
| `return_html_report_link` | boolean |  |  |
| `return_pdf_report_link` | boolean |  |  |

### Inputs

- `Queue_on_top` (`flag`)
- `Aurora_node_or_address` (`string`)

### Outputs

- `Date_completed` (`date`)
- `Error_count` (`int`)
- `Warning_count` (`int`)
- `Aurora_job_id` (`int`)
- `Aurora_status` (`string`)
- `Template_used` (`string`)
- `Time_to_complete` (`int`)
- `PDF_report_link` (`string`)
- `HTML_report_link` (`string`)
- `XML_report` (`string`)
- `HTML_report` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AzureServiceBusOperation

- **Display name**: Azure Service Bus Operation
- **Category**: Integration
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to perform an action onto an Azure Service Bus queue.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `azure_namespace` | string |  | `Azure_namespace` |
| `azure_key_name` | string |  | `Azure_key_name` |
| `azure_key` | string |  | `Azure_key` |
| `message_body` | text |  | `Message_body` |
| `queue_name` | string |  | `Queue or Topic name` |
| `subscription_name` | string |  | `Subscription_name` |
| `proxy_address` | string |  | `Proxy_url` |

### Inputs

- `Azure_namespace` (`string`, required)
- `Azure_key_name` (`string`, required)
- `Azure_key` (`string`, required)
- `Queue or Topic name` (`string`, required)
- `Proxy_url` (`string`, optional)
- `Subscription_name` (`string`, required)
- `Message_body` (`string`, required)

### Outputs

- `Message_body` (`string`)
- `Error_message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## AzureServiceBusTrigger

- **Display name**: Azure Service Bus Trigger
- **Category**: Integration
- **Version**: 0.1.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to watch for messages out of an Azure Service Bus queue

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `azure_namespace` | string |  | `Azure_namespace` |
| `azure_key_name` | string |  | `Azure_key_name` |
| `azure_key` | string |  | `Azure_key` |
| `queue_name` | string |  | `Queue or Topic name` |
| `subscription_name` | string |  | `Subscription_name` |
| `proxy_address` | string |  | `Proxy_url` |
| `keep_ongoing` | boolean |  |  |
| `polling_frequency` | integer | `10` (code) | `Polling_frequency` |

### Inputs

- `Azure_namespace` (`string`, required)
- `Azure_key_name` (`string`, required)
- `Azure_key` (`string`, required)
- `Queue or Topic name` (`string`, required)
- `Proxy_url` (`string`, optional)
- `Polling_frequency` (`int`, optional)
- `Subscription_name` (`string`, required)

### Outputs

- `Message_body` (`string`)
- `Error_message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## BatonFileCorrection

- **Display name**: Baton file correction
- **Category**: Quality Control
- **Version**: 0.5.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This Action plug-ins enables the submission of a file correction request to an Interra Baton Server

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server_node` | string |  |  |
| `baton_port` | integer | `8080` (code) |  |
| `server` | string |  |  |
| `user` | string |  | `Baton_server_user` |
| `password` | string |  | `Baton_server_password` |
| `test_plan` | text |  | `Test_plan` |
| `qc_report_as_xml` | text |  |  |
| `destination_folder` | string |  | `Destination_folder` |
| `output_format` | string | `Interra` (code) | `Output_format` |
| `polling_frequency` | integer | `5` (code) |  |
| `baton_task_id` | string |  | `Baton_task_id` |
| `baton_correction_port` | integer | `6060` (code) |  |
| `correction_server_flag` | boolean |  |  |
| `correction_server_ip` | string |  | `Correction_server_ip` |
| `baton_version` | string | `< 9` (code) | `Baton_version` |
| `api_token` | string |  | `Api_token` |

### Inputs

- `Baton_server_user` (`string`, optional)
- `Baton_server_password` (`string`, optional)
- `Test_plan` (`string`, optional)
- `Destination_folder` (`string`, required)
- `Output_format` (`string`, optional)
- `Baton_task_id` (`string`, required)
- `Baton_version` (`string`, optional)
- `Api_token` (`string`, required)
- `Correction_server_ip` (`string`, required)
- `Baton_server_address` (`string`)
- `Baton_node` (`string`)

### Outputs

- `Job_ID` (`string`)
- `Result` (`array`)
- `Start_time` (`date`)
- `Completion_time` (`date`)
- `Output_file` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## BatonFileVerification

- **Display name**: Baton file verification
- **Category**: Quality Control
- **Version**: 1.8.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This Action plug-ins enables the submission of a file verification request to an Interra Baton Server

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server` | string |  |  |
| `user` | string | `` (code) | `Baton_server_user` |
| `password` | string | `` (code) | `Baton_server_password` |
| `test_plan` | string |  | `Test_plan` |
| `plan_version` | integer |  |  |
| `priority` | string |  |  |
| `checkers` | string |  |  |
| `folder` | boolean |  |  |
| `polling_frequency` | integer |  |  |
| `server_node` | string |  |  |
| `baton_port` | int | `8080` (code) |  |
| `non_windows_install` | boolean |  |  |
| `force_pass_on_warning` | boolean |  |  |
| `input_source` | string |  |  |
| `return_xml_report` | boolean |  |  |
| `dynamic_test_plan_parameters` | text |  | `Dynamic_test_plan_parameters` |
| `verify_growing_file` | boolean |  |  |
| `polling_frequency_sec` | integer |  |  |
| `baton_version` | string |  | `Baton_version` |
| `expedite` | boolean | `false` |  |
| `stop_on_error` | boolean |  |  |
| `use_ssl` | boolean | `false` |  |
| `needed_cores` | integer | `1` |  |

### Inputs

- `Test_plan` (`string`, required)
- `Dynamic_test_plan_parameters` (`string`, optional)
- `Baton_server_user` (`string`, optional)
- `Baton_server_password` (`string`, optional)
- `Baton_version` (`string`, required)
- `Test_plan_version` (`int`)
- `Priority` (`string`)
- `Polling_frequency` (`int`)
- `Baton_port` (`int`)
- `Needed_cores` (`int`)
- `Baton_server_address` (`string`)
- `Baton_node` (`string`)

### Outputs

- `Task_ID` (`string` or `array`)
- `Result` (`string` or `array`)
- `Errors` (`int` or `array`)
- `Warnings` (`int` or `array`)
- `Start_time` (`date`)
- `Completion_time` (`date`)
- `Report_folder` (`string` or `array`)
- `Report_PDF_link` (`string` or `array`)
- `Report_XML_link` (`string` or `array`)
- `Report_VIDEO_link` (`string` or `array`)
- `XML_report` (`string` or `array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## BatonXmlReport

- **Display name**: Baton xml report
- **Category**: Quality Control
- **Version**: 0.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This Action plug-ins enables the retrieval of XML Report from Baton

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server` | string |  |  |
| `user` | string |  | `Baton_server_user` |
| `password` | string |  | `Baton_server_password` |
| `server_node` | string |  |  |
| `baton_port` | integer | `8080` (code) |  |
| `task_ids` | string |  | `taskIDs` |
| `baton_version` | string | `< 9` (code) | `Baton_version` |

### Inputs

- `taskIDs` (`string` or `array`, required)
- `Baton_server_user` (`string`, required)
- `Baton_server_password` (`string`, required)
- `Baton_version` (`string`, optional)
- `Baton_port` (`int`)
- `Baton_server_address` (`string`)
- `Baton_node` (`string`)

### Outputs

- `XML_report` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## BitmovinEncoding

- **Display name**: Bitmovin encoding
- **Category**: Transcoding
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plug-in provides the ability to start and monitor a Bitmovin encoding.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `server_address` | string | `api.bitmovin.com` (code) |  |
| `server_port` | integer | `443` (code) |  |
| `polling_frequency` | integer | `10` (code) |  |
| `source` | string |  | `Source file path` |
| `api_key` | string |  | `Bitmovin API key` |
| `output_format` | string |  |  |
| `output_path` | string |  | `Output path root` |
| `input_id` | string |  |  |
| `output_id` | string |  |  |
| `cloud_region` | string | `AUTO` (code) | `Cloud region` |
| `infrastructure_id` | string | `` (code) | `Infrastructure id` |
| `streams` | text |  |  |
| `segment_length` | integer | `4` (code) | `Segment length` |
| `overwrite` | boolean | `false` (code) |  |

### Inputs

- `Source file path` (`string`, required)
- `Bitmovin API key` (`string`, required)
- `Cloud region` (`string`, optional)
- `Infrastructure id` (`string`, optional)
- `Output path root` (`string`, required)
- `Segment length` (`int`, optional)

### Outputs

- `result` (`string`)
- `result_json` (`string`)
- `manifest_names` (`string`)
- `Step_information` (`hash`)

## CambriaFtcTranscoder

- **Display name**: Cambria ftc transcoder
- **Category**: Other Utilities
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: Add description here

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `remote_node` | string |  |  |
| `server_address` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `api_port` | integer | `CLUSTER_API_PORT` (code) | `Api_port` |
| `transcoding_payload` | text |  | `Transcoding_payload` |

### Inputs

- `Transcoding_payload` (`string`, required)
- `Api_port` (`int`, optional)
- `Remote_node_or_address` (`string`)

### Outputs

- `Detailed_response` (`hash`)
- `Output_filename` (`string`)
- `Remote_node_or_address` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## CarbonCoderTranscoding

- **Display name**: Carbon/WFS transcoding
- **Category**: Transcoding
- **Version**: 1.4.1 (requires Orchestrator 4.1.0 or later)
- **Description**: This is Action plug-ins provides the ability to submit file transcoding job to a Harmonic Carbon Coder/WFS server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server_address` | string |  |  |
| `carbon_api_port` | integer | `1120` (code) |  |
| `polling_frequency` | integer | `5` (code) |  |
| `transcoding_payload` | text | `<Sources><Module_0 Filename=\"<%= File_name %>\"/></Sources><Destinations><Module_0 ModuleGUID=\"<%= module_GUID %>\" ><ModuleData CML_P_BaseFileName=\"%s\" CML_P_Path=\"<%= Target_dir %>\"/></Module_0></Destinations>` (code) | `Transcoding_payload` |
| `transcoding_payload_file` | string |  |  |
| `saved_inputs` | text |  |  |
| `server_node` | string |  |  |
| `api_version` | string |  |  |
| `wfs_workflow_id` | string |  | `Wfs_workflow_id` |
| `source` | string |  | `Source_file_path` |
| `target` | string | `` (code) | `Target_file_path` |
| `wfs_api_port` | string | `1301` (code) |  |
| `carbon_job_name` | string |  | `Carbon_Job_Name` |

### Inputs

- `Transcoding_payload` (`string`, optional)
- `Source_file_path` (`string`, required)
- `Target_file_path` (`string`, optional)
- `Wfs_workflow_id` (`string`, required)
- `Carbon_Job_Name` (`string`, optional)
- `Errors` (`array`)
- `Warnings` (`array`)
- `Job_GUID` (`string`)
- `input_file` (`string`)
- `output_file(s)` (`array`)
- `Carbon_API_port` (`int`)
- `Carbon_server_address` (`string`)

### Outputs

- `Errors` (`array`)
- `Warnings` (`array`)
- `Job_GUID` (`string`)
- `input_file` (`string`)
- `output_file(s)` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## CatdvRestRequest

- **Display name**: CatdvRestRequest
- **Category**: Integration
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides capability to perform REST operations on CatDV server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `service_url` | string |  | `Service_url` |
| `rest_method` | string |  | `Rest_method` |
| `basic_auth_login` | string |  | `Basic_auth_login` |
| `basic_auth_password` | string |  | `Basic_auth_password` |
| `rest_endpoint` | string |  | `Rest_endpoint` |
| `selector` | string | `` (code) | `Selector` |
| `polling_frequency` | integer | `5` (code) |  |
| `polling_stop_condition` | text | `true` (code) |  |
| `post_body` | text | `` (code) | `Post_body` |
| `query_parameters` | text | `{}` (code) | `Query_parameters` |
| `keep_ongoing` | boolean |  |  |

### Inputs

- `Service_url` (`string`, required)
- `Basic_auth_login` (`string`, required)
- `Basic_auth_password` (`string`, required)
- `Rest_method` (`string`, required)
- `Rest_endpoint` (`string`, required)
- `Selector` (`string`, optional)
- `Query_parameters` (`string`, optional)
- `Post_body` (`string`, optional)

### Outputs

- `response_code` (`int`)
- `session_hash` (`hash`)
- `session_status` (`string`)
- `status` (`string`)
- `result_hash` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## CerifyFileVerification

- **Display name**: Cerify File Verification
- **Category**: Quality Control
- **Version**: 0.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This Action plug-in provides the ability to submit a quality control task to a Cerify Server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server_node` | string |  |  |
| `server_address` | string |  |  |
| `server_api_port` | integer | `80` (code) |  |
| `media_location_name` | string |  | `Media_location_name` |
| `media_url` | string |  | `Media_url` |
| `profile_name` | string |  | `Profile_name` |
| `priority` | string | `Low` (code) |  |
| `job_name` | string |  | `Job_name` |
| `keep_media_set_on_server` | boolean |  |  |
| `force_pass_on_warning` | boolean |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `force_job_name` | boolean | `false` (code) | `Force_job_name` |

### Inputs

- `Media_location_name` (`string`, required)
- `Media_url` (`string`, required)
- `Profile_name` (`string`, required)
- `Job_name` (`string`, required)
- `Force_job_name` (`flag`, optional)
- `Cerify_server_address` (`string`)

### Outputs

- `File_Verification_Result` (`string`)
- `Job_Name` (`string`)
- `Input_Media_Params` (`hash`)
- `File_Stats` (`hash`)
- `Alerts` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## ClamavCheck

- **Display name**: ClamAV check
- **Category**: Virus Scan
- **Version**: 0.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to check a file, folder or set of files for viruses using the clamAV utility.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execution_node` | string |  |  |
| `execution_login` | string |  |  |
| `execution_password` | string |  |  |
| `binary_path` | string | `clamscan` (code) | `Binary_path` |
| `input_file_path` | string |  | `Input_file_path` |
| `include_files_pattern` | string |  |  |
| `exclude_files_pattern` | string |  |  |
| `quarantine_folder` | string |  |  |
| `clean_folder` | string |  |  |
| `file_base` | string |  |  |
| `fail_on_infection` | boolean |  |  |
| `return_full_report` | boolean |  |  |
| `options` | string | `-r` (code) | `Options` |
| `single_file_mode` | boolean |  |  |
| `truncate_infected_file` | boolean |  |  |
| `max_scan_size` | integer |  |  |
| `above_max_action` | string |  |  |

### Inputs

- `Input_file_path` (`string`, required)
- `Options` (`string`, optional)
- `Binary_path` (`string`, optional)
- `ClamAV_node` (`string`)

### Outputs

- `Clean_files` (`array`)
- `Infected_files` (`array`)
- `Infection_report` (`string`)
- `Output_file_path` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## CollectionManager

- **Display name**: Collection manager
- **Category**: Other Utilities
- **Version**: 0.3.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in enables creating a name-value pair collection (Hash) or adding fields to an existing one.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `optional_elements` | text |  |  |
| `mandatory_elements` | text |  |  |
| `use_json` | boolean |  |  |
| `extracted_outputs` | text |  |  |
| `use_pretty_json` | boolean |  |  |
| `use_toml` | boolean |  |  |

### Inputs

- `Source_collection` (`hash`)
- `Source_JSON_collection` (`string`)

### Outputs

- `Modified_collection` (`hash`)
- `Modified_JSON_collection` (`string`)
- `Modified_pretty_JSON_collection` (`string`)
- `Modified_TOML_collection` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## ConsoleNotification

- **Display name**: Console notification
- **Category**: User Interactions
- **Version**: 0.5.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides the ability to insert entries in the Aspera Console database representing Orchestrator workflow events, enabling integration between Orchestrator and Console for comprehensive monitoring and tracking of automated transfer activities.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `console_host` | string |  |  |
| `console_db_port` | integer |  |  |
| `console_db_user` | string |  | `Console_DB_user` |
| `console_db_password` | string |  | `Console_DB_password` |
| `console_db` | string |  |  |
| `event_payload` | text | `<%= event_name %>` (code) |  |
| `saved_inputs` | text |  |  |
| `journal` | boolean |  |  |
| `journal_step` | string |  |  |
| `journal_status` | string |  |  |
| `use_node_credentials` | boolean |  |  |
| `bytes_transferred` | bigint |  |  |
| `bytes_written` | bigint |  |  |
| `raw_cookie` | string | `aspera.orchestrator:<%= workstep_id %>:<%= event %>` (code) |  |

### Inputs

- `Console_DB_user` (`string`, required)
- `Console_DB_password` (`string`, required)
- `node_from` (`string`)
- `node_to` (`string`)
- `session_status` (`string`)
- `session_start` (`date`)
- `session_stop` (`date`)
- `session_user` (`string`)
- `operation` (`string`)
- `destination_path` (`string`)
- `files_complete` (`array`)
- `files_failed` (`array`)
- `error_message` (`string`)
- `Bytes_transferred` (`string`)
- `Bytes_written` (`string`)
- `package` (`string`)
- `journal_status` (`string`)
- `journal_step` (`string`)
- `Console_node_or_address` (`string`)
- `Console_DB_port` (`int`)

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## ConsoleSmartTransferOperation

- **Display name**: Console Smart Transfer
- **Category**: File Transfer
- **Version**: 0.2.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides the ability to initiate Smart Transfer templates in Aspera Console or to list available templates.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `console_ip` | text |  | `Console_ip` |
| `console_port` | integer | `443` (code) | `Console_port` |
| `source_path_list` | string | `[]` (code) | `Source_path_list` |
| `source_base` | string | `` (code) | `Source_base` |
| `smart_transfer_id` | integer |  | `Smart_transfer_id` |
| `transfer_name` | string | `` (code) | `Transfer_name` |
| `transfer_comments` | string | `` (code) | `Transfer_comments` |
| `operation` | string |  |  |
| `login` | string |  | `Login` |
| `password` | string |  | `Password` |
| `monitor_status` | boolean |  |  |
| `polling_frequency` | integer | `10` (code) |  |

### Inputs

- `Login` (`string`, required)
- `Password` (`string`, required)
- `Console_ip` (`string`, required)
- `Console_port` (`int`, optional)
- `Smart_transfer_id` (`int`, required)
- `Source_base` (`string`, optional)
- `Transfer_name` (`string`, optional)
- `Transfer_comments` (`string`, optional)
- `Source_path_list` (`string`, optional)
- `source_path_list` (`array`)

### Outputs

- `Transfer_Ids` (`array`)
- `Transfer_Status` (`string`)
- `Raw_Output` (`hash`)
- `Smart_Template_List` (`array`)
- `Error_Message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## ConvertPath

- **Display name**: Path conversion
- **Category**: File Operations
- **Version**: 0.2.1 (requires Orchestrator 4.1.6 or later)
- **Description**: Converts an absolute file path from one mount point to another based on configured input and output mappings. Supports one-to-one and multi-mount point conversions.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `file_path` | text |  | `File_path` |
| `input_mount_point` | text |  | `Input_mount_point` |
| `output_mount_point` | text |  | `Output_mount_point` |
| `array_mode` | boolean |  |  |

### Inputs

- `Input_mount_point` (`string`, required)
- `Output_mount_point` (`string`, required)
- `File_path` (`string`, required)
- `File_paths` (`array`)

### Outputs

- `output_file_paths` (`array`)
- `output_file_nakednames` (`array`)
- `output_file_basenames` (`array`)
- `output_file_dirnames` (`array`)
- `output_file_nakeddirs` (`array`)
- `output_file_extensions` (`array`)
- `output_file_path` (`string`)
- `output_file_nakedname` (`string`)
- `output_file_basename` (`string`)
- `output_file_dirname` (`string`)
- `output_file_nakeddir` (`string`)
- `output_file_extension` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## CorbaOperation

- **Display name**: Corba Operation
- **Category**: Integration
- **Version**: 0.1.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin is used to make a CORBA call to the Arris CMM (Content Management and Metadata server) using the JacORB utility.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `corba_ip` | string |  | `Corba_ip` |
| `port` | integer |  | `Port` |
| `name_service` | string |  | `Name_service` |
| `ftp_url` | text |  | `Ftp_url` |
| `factory_name` | string |  | `Factory_name` |
| `package_name` | string |  | `Package_name` |
| `log_file_path` | text |  | `Log_file_path` |

### Inputs

- `Corba_ip` (`string`, required)
- `Ftp_url` (`string`, required)
- `Port` (`int`, required)
- `Name_service` (`string`, required)
- `Factory_name` (`string`, required)
- `Package_name` (`string`, required)
- `Log_file_path` (`string`, required)

### Outputs

- `Corba_Call_Validation` (`flag`)
- `Raw_Execution_Output` (`string`)
- `Log_File_Path` (`string`)
- `Log_File_Content` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## CurlOperation

- **Display name**: Curl Operations
- **Category**: Integration
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in executes curl command operations on remote nodes via SSH, supporting GET and POST requests with authentication, flexible parameter handling, image downloads, and configurable result storage for comprehensive HTTP operations.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `remote_node` | string |  | `Remote_node` |
| `service_url` | string |  | `Service_url` |
| `login` | string |  |  |
| `password` | string |  |  |
| `request_type` | string |  | `Request_type` |
| `detail_info` | boolean |  |  |
| `entire_command` | string |  | `Entire_command` |
| `operation` | string |  |  |
| `is_parameter_a_file` | boolean |  |  |
| `parameters` | string |  |  |
| `redirect_automatically` | boolean |  |  |
| `download_image` | boolean |  |  |
| `image_location` | string |  | `Image_location` |
| `result_file_path` | string |  | `Result_file_path` |
| `options` | string |  |  |

### Inputs

- `Remote_node` (`string`, required)
- `Service_url` (`string`, required)
- `Request_type` (`string`, required)
- `Result_file_path` (`string`, required)
- `Entire_command` (`string`, required)
- `Image_location` (`string`, required)
- `Execution Result` (`string`)
- `Execution Result Path` (`string`)
- `Error Message Received` (`string`)
- `Image Download Location` (`string`)

### Outputs

- `Execution Result` (`string`)
- `Execution Result Path` (`string`)
- `Error Message Received` (`string`)
- `Image Download Location` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## CustomProgressNotifier

- **Display name**: Custom progress notifier
- **Category**: Integration
- **Version**: 0.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides the ability to intercept progress notifications from a step and add custom behavior to it. For example, logging to an external log file or RSS feed.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `action_type` | string |  |  |
| `action_id` | integer |  |  |
| `bypass_standard_notification` | boolean |  |  |
| `report_progress_code` | text |  |  |
| `keep_alive_code` | text |  |  |
| `additional_mandatory_inputs` | text |  |  |
| `additional_optional_inputs` | text |  |  |
| `additional_outputs` | text |  |  |

### Inputs

- None found in source.

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## CustomPython

- **Display name**: Custom Python
- **Category**: Other Utilities
- **Version**: 0.1.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in can be used to script in python for some customized behaviour.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execute_code` | text |  |  |
| `use_code_from_github` | boolean |  |  |
| `github_token` | string |  | `Github_token` |
| `github_repo` | string |  | `Github_repo` |
| `github_file_path` | text |  | `Github_file_path` |
| `github_branch_name` | string | `main` (code) | `Github_branch_name` |
| `github_user_name` | string |  | `Github_user_name` |
| `github_hostname` | string |  | `Github_hostname` |
| `verify_ssl` | boolean | `true` |  |
| `use_cached` | boolean | `false` |  |
| `mandatory_inputs` | text |  |  |
| `optional_inputs` | text |  |  |
| `typed_outputs` | text |  |  |
| `flask_server_port` | integer | `3200` | `Flask_server_port` |
| `source_control_type` | string | `github` |  |

### Inputs

- `Flask_server_port` (`int`, required)
- `Github_hostname` (`string`, optional)
- `Github_token` (`string`, optional)
- `Github_repo` (`string`, required)
- `Github_file_path` (`string`, required)
- `Github_branch_name` (`string`, optional)
- `Github_user_name` (`string`, required)

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Outputs are partly defined by template fields: see the template attributes.

## CustomRuby

- **Display name**: Custom Ruby
- **Category**: Other Utilities
- **Version**: 0.7.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in can be used to script in ruby some customized behaviour.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execute_code` | mediumtext |  |  |
| `use_code_from_github` | boolean |  |  |
| `github_token` | string |  | `Github_token` |
| `github_repo` | string |  | `Github_repo` |
| `github_file_path` | text |  | `Github_file_path` |
| `github_branch_name` | string | `main` (code) | `Github_branch_name` |
| `github_user_name` | string |  | `Github_user_name` |
| `github_hostname` | string |  | `Github_hostname` |
| `verify_ssl` | boolean | `true` |  |
| `use_cached` | boolean | `false` |  |
| `inputs_spec_code` | text |  |  |
| `outputs_spec_code` | text |  |  |
| `validate_inputs_code` | text |  |  |
| `mandatory_inputs` | text |  |  |
| `optional_inputs` | text |  |  |
| `typed_outputs` | text |  |  |
| `source_control_type` | string | `github` |  |

### Inputs

- `Github_hostname` (`string`, optional)
- `Github_token` (`string`, optional)
- `Github_repo` (`string`, required)
- `Github_file_path` (`string`, required)
- `Github_branch_name` (`string`, optional)
- `Github_user_name` (`string`, required)

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## CustomTrigger

- **Display name**: Custom trigger
- **Category**: Triggers
- **Version**: 0.4.2 (requires Orchestrator 4.1.6 or later)
- **Description**: The Custom Trigger Plugin allows workflows to be initiated based on custom Ruby logic that runs periodically until a defined condition is met.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execute_code` | text |  |  |
| `check_status_code` | text |  |  |
| `allow_multiple` | boolean |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `direct_pausable` | boolean |  |  |
| `should_cancel` | boolean |  |  |
| `inputs_spec_code` | text |  |  |
| `outputs_spec_code` | text |  |  |
| `validate_inputs_code` | text |  |  |
| `mandatory_inputs` | text |  |  |
| `optional_inputs` | text |  |  |
| `typed_outputs` | text |  |  |

### Inputs

- None found in source.

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## DaletAssetManagement

- **Display name**: Dalet Asset Management Plugin
- **Category**: Asset Management
- **Version**: 0.2.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plug-in provides the ability to interact with Dalet Asset Management System.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `user_name` | text |  |  |
| `password` | text |  |  |
| `soap_wsdl_path` | text |  | `Soap_wsdl_path` |
| `operations` | text |  |  |
| `payload_file` | string |  |  |
| `saved_inputs` | string |  |  |
| `payload` | text |  |  |

### Inputs

- `Soap_wsdl_path` (`string`, required)

### Outputs

- `response` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## DatabaseQuery

- **Display name**: Database query
- **Category**: Integration
- **Version**: 0.3.4 (requires Orchestrator 4.1.6 or later)
- **Description**: This plug-in provides the ability to execute SQL queries on external databases (MySQL, Oracle, ODBC compatible) and format their results with flexible output options.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `database_type` | string | `Database::DATABASE_MYSQL` (code) |  |
| `database_name` | string |  |  |
| `database_host` | string |  |  |
| `database_port` | string |  |  |
| `database_user` | string |  |  |
| `database_password` | string |  |  |
| `database_query` | text |  | `SQL_query` |
| `row_formatting_code` | text |  | `Row_formatting_code` |
| `result_formatting_code` | text |  | `Result_formatting_code` |
| `result_type` | string | `TYPE_ARRAY` (code) |  |
| `database_node` | string |  |  |

### Inputs

- `SQL_query` (`string`, required)
- `Row_formatting_code` (`string`, optional)
- `Result_formatting_code` (`string`, optional)
- `DB_type` (`string`)
- `VAR_DATABASE_HOST` (`string`)
- `DB_node` (`string`)
- `DB_port` (`int`)
- `VAR_DATABASE_NAME` (`string`)
- `DB_user` (`string`)
- `DB_password` (`pwd`)

### Outputs

- `Inserted Id` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## DatabaseTrigger

- **Display name**: Database trigger
- **Category**: Triggers
- **Version**: 1.1.6 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides the ability to periodically execute SQL queries on external databases (MySQL, Oracle, ODBC compatible) and trigger workflows when new rows are found.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `database_type` | string | `Database::DATABASE_MYSQL` (code) |  |
| `database_name` | string |  |  |
| `database_host` | string |  |  |
| `database_port` | string |  |  |
| `database_user` | string |  |  |
| `database_password` | string |  |  |
| `database_query` | text |  |  |
| `row_formatting_code` | text |  |  |
| `result_formatting_code` | text |  |  |
| `result_type` | string |  |  |
| `polling_frequency` | integer | `10` (code) |  |
| `max_rows` | integer | `1` (code) |  |
| `post_trigger_query` | text |  |  |
| `keep_ongoing` | boolean |  |  |
| `trigger_type` | string |  |  |

### Inputs

- `Keep_ongoing` (`flag`)
- `SQL_query` (`string`)
- `DB_host` (`string`)
- `DB_port` (`int`)
- `DB_type` (`string`)
- `DB_name` (`string`)
- `DB_user` (`string`)
- `DB_password` (`string`)

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## DependencyChecker

- **Display name**: Dependency checker
- **Category**: Other Utilities
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: The DependencyChecker plug-in monitors the presence of specific files in a defined location and allows workflows to pause until those files are detected. This ensures that dependent data is available before proceeding to the next step.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `dependency_paths` | string |  |  |
| `polling_frequency` | integer | `10` (code) |  |
| `stability_period` | integer | `10` (code) |  |
| `base_path` | string | `` (code) |  |
| `accept_partial_files` | boolean | `false` (code) |  |
| `timeout_in_sec` | integer | `0` (code) |  |

### Inputs

- `Dependency_paths` (`array`)

### Outputs

- `Dependency file paths` (`array`)
- `Pending files` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## DigitalrapidsStreamTranscoding

- **Display name**: Imagine StreamZ transcoding
- **Category**: Transcoding
- **Version**: 0.4.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This is Action plug-ins provides the ability to submit file transcoding job to a DigitalRapids Stream server. This has been obsoleted by the DigitalRapids TM plugin.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `stream_node` | string |  |  |
| `stream_server_address` | string |  |  |
| `stream_port` | integer | `43778` (code) |  |
| `stream_wsdl_uri` | string |  |  |
| `stream_user_name` | string |  |  |
| `stream_user_password` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `project_name` | string |  |  |
| `ad_hoc_project_name` | string |  |  |
| `ad_hoc_project_xml` | mediumtext |  |  |
| `source_template` | string |  |  |
| `destination_path` | string |  |  |
| `no_progress_timeout` | integer |  |  |
| `encoder_wait_timeout` | integer |  |  |
| `destination_template` | string |  |  |

### Inputs

- `Project XML Definition` (`string`)
- `Stream_server` (`string`)
- `Stream_server_port` (`int`)

### Outputs

- `Output_files` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## DigitalrapidsTmTranscoding

- **Display name**: Imagine TM transcoding
- **Category**: Transcoding
- **Version**: 0.4.1 (requires Orchestrator 4.1.0 or later)
- **Description**: This is Action plug-in provides the ability to submit a file transcoding job to a DigitalRapids Transcode Manager server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `tm_node` | string |  |  |
| `tm_server_address` | string |  |  |
| `tm_api_port` | integer | `44000` (code) |  |
| `project_path` | string |  | `Project_path` |
| `project_id` | string |  | `Project_id` |
| `group_name` | string |  | `Group_name` |
| `tm_group_id` | string |  | `Tm_group_id` |
| `role` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `source_file` | string |  | `Source_file` |
| `destination_dir` | string |  | `Destination_dir` |
| `priority` | string | `0` (code) |  |
| `tag_values` | mediumtext | `` (code) | `Tag_values` |
| `separate_audio_source` | boolean | `false` |  |
| `audio_source_file` | string |  |  |

### Inputs

- `Source_file` (`string`, required)
- `Project_id` (`string`, required)
- `Tm_group_id` (`string`, required)
- `Group_name` (`string`, required)
- `Project_path` (`string`, required)
- `Destination_dir` (`string`, optional)
- `Tag_values` (`string`, optional)
- `Transcode_manager_server` (`string`)
- `Audio_Source_Filepath` (`string`)

### Outputs

- `Output_files` (`array`)
- `Errors_during_transcode` (`array`)
- `Job_id` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## DivaArchive

- **Display name**: Diva archive
- **Category**: File Operations
- **Version**: 0.4.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to archive or restore files to/from the DIVArchive system. It implements the DIVA REST WEB services API 1.0, 2.1 and 2.2

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `remote_node` | string |  |  |
| `server_address` | string |  | `server address` |
| `server_port` | integer | `9763` (code) | `server port` |
| `operation` | string |  |  |
| `polling_frequency` | integer | `10` (code) |  |
| `object_name` | string |  | `object name` |
| `object_category` | string |  |  |
| `media_type` | string |  | `source / dest` |
| `media_name` | string |  | `media name` |
| `file_path_root` | string |  | `filepath root` |
| `file_name_list` | string |  | `filename list` |
| `qos` | integer |  | `Qos` |
| `priority` | integer | `-1` (code) | `priority` |
| `options` | string |  | `Options` |
| `instance_id` | integer |  |  |
| `format` | integer |  | `format` |
| `parameters` | string |  | `partial restore parameters` |
| `diva_version` | string |  |  |
| `basic_auth_login` | string |  | `Basic auth login` |
| `basic_auth_password` | string |  | `Basic auth password` |

### Inputs

- `server address` (`string`, required)
- `server port` (`int`, optional)
- `object name` (`string`, required)
- `priority` (`int`, optional)
- `source / dest` (`string`, required)
- `Options` (`string`, optional)
- `Qos` (`int`, optional)
- `partial restore parameters` (`string`, required)
- `format` (`int`, required)
- `media name` (`string`, required)
- `filepath root` (`string`, required)
- `filename list` (`string`, required)
- `Basic auth login` (`string`, required)
- `Basic auth password` (`string`, required)
- `object category` (`string`)
- `polling_frequency` (`int`)

### Outputs

- `XML_result` (`string`)
- `HASH_result` (`hash`)
- `Diva_status_message` (`string`)
- `Diva_request_status_message` (`string`)
- `Avid mob id` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## DolbyOperation

- **Display name**: Dolby VM600/DP600
- **Category**: Transcoding
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides the ability to invoke Dolby VM600/DP600 API operations for audio processing and workflow management.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `url` | string |  | `Url` |
| `api_operation` | string |  | `Api_operation` |
| `workorder_name` | string |  | `Workorder_name` |
| `workorder_type` | string |  | `Workorder_type` |
| `source_filename` | string |  | `Source_filename` |
| `destination_filename` | string |  | `Destination_filename` |
| `workflow_profile` | string |  | `Workflow_profile` |
| `workorder_priority` | integer |  | `Workorder_priority` |
| `polling_frequency` | integer | `5` (code) |  |
| `delete_on_cancel` | boolean | `false` |  |

### Inputs

- `Api_operation` (`string`, required)
- `Url` (`string`, required)
- `Workorder_name` (`string`, required)
- `Workorder_type` (`string`, required)
- `Source_filename` (`string`, required)
- `Destination_filename` (`string`, required)
- `Workflow_profile` (`string`, required)
- `Workorder_priority` (`int`, required)

### Outputs

- `Workflows List` (`hash`)
- `Workflows List Count` (`int`)
- `Error Message` (`hash`)
- `XML Response` (`hash`)
- `Refresh Time` (`int`)
- `Correlation Id` (`string`)
- `Status` (`string`)
- `Step_information` (`hash`)

## ElementalMediaConvert

- **Display name**: Elemental Media Convert
- **Category**: Transcoding
- **Version**: 0.4.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This Action plugin provides the ability to submit a file transcoding job to the AWS Elemental MediaConvert service.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `access_key` | string |  | `Access_key_value` |
| `secret_key` | string |  | `Secret_key_value` |
| `region` | string |  | `Region` |
| `endpoint` | string |  | `Endpoint` |
| `role` | string |  | `Role` |
| `source` | string |  | `Input_file_path` |
| `target` | string |  | `Output_folder_path` |
| `job_template_id` | string |  | `Job template id` |
| `queue_id` | string |  |  |
| `json_payload` | text | `` (code) | `Custom JSON payload` |
| `polling_frequency` | integer | `5` (code) |  |
| `reload_job_template` | boolean | `false` |  |
| `destinations` | string | `` (code) | `Destinations` |
| `operation` | string | `OPERATION_CONVERT` (code) | `Operation` |
| `job_id` | string |  | `Job_id` |

### Inputs

- `Job_id` (`string`, required)
- `Access_key_value` (`string`, required)
- `Secret_key_value` (`string`, required)
- `Region` (`string`, required)
- `Operation` (`string`, optional)
- `Destinations` (`string`, optional)
- `Endpoint` (`string`, optional)
- `Input_file_path` (`string`, required)
- `Output_folder_path` (`string`, required)
- `Role` (`string`, required)
- `Job template id` (`string`, required)
- `Custom JSON payload` (`string`, optional)

### Outputs

- `result` (`string`)
- `result_json` (`string`)
- `result_job_template_json` (`string`)
- `job_id` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## ElementalTranscoding

- **Display name**: Elemental transcoding
- **Category**: Transcoding
- **Version**: 0.7.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides the ability to submit file transcoding jobs to an Elemental server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server_node` | string |  |  |
| `server_address` | string |  |  |
| `api_port` | string | `443` (code) | `Elemental_API_port` |
| `user_name` | string | `admin` (code) |  |
| `source` | string |  | `Source_file_path` |
| `target` | string |  |  |
| `profile_id` | string |  | `Profile_id` |
| `api_key` | string |  |  |
| `authentication` | boolean | `false` (code) |  |
| `polling_frequency` | integer | `5` (code) |  |
| `xml_payload` | mediumtext | `"<?xml version=\"1.0\" encoding=\"UTF-8\"?><job>" +` (code) | `Xml_payload` |
| `proxy_address` | string |  |  |
| `proxy_port` | integer |  |  |
| `use_ssl` | boolean |  |  |
| `authenticate_for_s3` | boolean |  |  |
| `s3_authentication_type` | string | `basic` (code) | `S3_authentication_type` |
| `s3_shared_key` | string |  | `S3_shared_key` |
| `s3_secret_key` | text |  | `S3_secret_key` |
| `return_error` | boolean | `false` | `Return_error` |

### Inputs

- `Elemental_API_port` (`string`, optional)
- `Return_error` (`flag`, required)
- `Source_file_path` (`string`, required)
- `Profile_id` (`string`, required)
- `S3_shared_key` (`string`, required)
- `S3_secret_key` (`string`, required)
- `S3_authentication_type` (`string`, optional)
- `Xml_payload` (`string`, optional)
- `Elemental_server_address` (`string`)
- `API_key_value` (`string`)
- `User_name` (`string`)
- `Proxy_server_address` (`string`)
- `Proxy_port` (`int`)

### Outputs

- `Output_file(s)` (`array`)
- `Errors` (`array`)
- `Job_Id` (`string`)
- `Input_file` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## EmailInboxWatcher

- **Display name**: Email inbox watcher
- **Category**: Triggers
- **Version**: 0.4.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides a way to trigger workflows based on the arrival of incoming packages in a IMAP inbox.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server` | string |  |  |
| `port` | integer | `143` (code) |  |
| `use_ssl` | boolean |  |  |
| `email_protocol` | string |  |  |
| `email_node` | string |  |  |
| `user` | string |  |  |
| `password` | string |  |  |
| `filters` | text | `ALL` (code) |  |
| `mailbox_folder` | string |  |  |
| `new_only` | boolean |  |  |
| `keep_ongoing` | boolean |  |  |
| `polling_frequency` | integer |  |  |
| `archive_folder` | string |  |  |
| `download_attachments` | boolean | `false` (code) |  |
| `attachments_target_folder` | string | `"` (code) |  |
| `encoding` | string |  |  |

### Inputs

- `Polling_frequency` (`int`)
- `Email_server_address` (`string`)
- `Email_server_port` (`int`)
- `Filters_override` (`string`)

### Outputs

- `Subject` (`string`)
- `Body` (`string`)
- `HTML_Body` (`string`)
- `Date` (`date`)
- `To` (`array`)
- `Cc` (`array`)
- `From` (`string`)
- `Reply_to` (`string`)
- `Id` (`int`)
- `Message_id` (`string`)
- `Attachments` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## EmailNotification

- **Display name**: Email notification
- **Category**: User Interactions
- **Version**: 0.7.4 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides the ability to send email as part of the execution of a workflow. It can be configured with recipients, subject, message body, and optional sender details to enable workflow-driven email notifications.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `template` | text | `<font color=\"gray\">eMail generated by Aspera Orchestrator</font>` (code) | `Template` |
| `payload` | text | `<MessageDefinition><Destinations><To><%= To %></To></Destinations><Subject><%= Subject %></Subject></MessageDefinition>` (code) |  |
| `mailer_name` | string |  |  |
| `attachment_list` | text |  | `Attachment_list` |
| `subject_line` | text |  | `Subject` |
| `destinations` | text |  | `To` |
| `reply_to` | string |  | `Reply_to` |
| `from_name` | string |  | `From_name` |
| `from_address` | string |  | `From_address` |
| `use_payload` | boolean |  |  |
| `only_accept_full_email_address` | boolean | `false` (code) | `Only_accept_full_email_address` |
| `force_base64` | boolean |  |  |

### Inputs

- `Template` (`string`, optional)
- `Only_accept_full_email_address` (`flag`, optional)
- `Attachment_list` (`string`, required)
- `To` (`string`, required)
- `Subject` (`string`, required)
- `Reply_to` (`string`, optional)
- `From_name` (`string`, optional)
- `From_address` (`string`, optional)
- `MessageDefinition_Override` (`string`)
- `attachment_list` (`array`)

### Outputs

- `FullMessage` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## EmotionOperation

- **Display name**: Emotion operation
- **Category**: Transcoding
- **Version**: 1.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to invoke Emotion API operation.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `api_operation` | string |  | `API Operation` |
| `service_url` | string |  | `Service_url` |
| `source` | string |  | `source` |
| `destination` | string | `{}` (code) | `destination` |
| `job_uuid` | string |  | `Job_uuid` |
| `workflow_uuid` | string |  | `Workflow_uuid` |
| `report` | string |  |  |
| `api_inputs` | string | `{}` (code) | `api_inputs` |
| `api_outputs` | string | `{}` (code) | `api_outputs` |
| `job_title` | string | `` (code) | `Job_title` |
| `payload` | text |  | `Payload` |
| `polling_frequency` | integer | `10` (code) | `Polling_frequency` |

### Inputs

- `API Operation` (`string`, required)
- `Service_url` (`string`, required)
- `api_inputs` (`string` or `hash`, optional)
- `api_outputs` (`string` or `hash`, optional)
- `Polling_frequency` (`int`, optional)
- `Job_uuid` (`string`, required)
- `Workflow_uuid` (`string`, required)
- `source` (`string`, required)
- `destination` (`string`, optional)
- `Job_title` (`string`, optional)
- `Payload` (`string`, required)
- `job_uuid` (`string`)

### Outputs

- `job uuid` (`string`)
- `Error` (`string`)
- `Response Message` (`string`)
- `Job Raw Response` (`hash`)
- `State Description` (`string`)
- `Workflows List` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## EncodingdotcomTranscoding

- **Display name**: Encoding.com transcoding
- **Category**: Transcoding
- **Version**: 0.3.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This Action plug-in provides the ability to submit file encoding job to a Encoding.com server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `user_id` | string |  | `User_id` |
| `api_key` | string |  | `Api_key` |
| `operation` | string |  | `Operation` |
| `use_ssl` | boolean |  |  |
| `delete_after_encoding_success` | boolean |  |  |
| `source_files` | text |  |  |
| `media_ids` | string |  |  |
| `output_format` | string |  |  |
| `notify_url` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `custom_payload` | mediumtext |  | `Custom_payload` |
| `use_json` | boolean |  |  |

### Inputs

- `User_id` (`string`, required)
- `Api_key` (`string`, required)
- `Operation` (`string`, required)
- `Custom_payload` (`string`, required)
- `Source_file` (`string`)
- `Output_format` (`string`)
- `Media_Ids` (`string`)

### Outputs

- `Input_and_Output_media` (`hash`)
- `Errors` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## EnvivioVodEncoding

- **Display name**: Envivio transcoding
- **Category**: Transcoding
- **Version**: 1.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This is Action plug-ins provides the ability to submit file encoding jobs to an Envivio VOD Encoder thru a 4Balancer manager.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `balancer_node` | string |  |  |
| `balancer_server_address` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `preset_id` | string |  | `Preset_ID` |
| `job_name` | string |  | `Job_name` |
| `input_filename` | string |  | `Input_filename` |
| `output_filename` | string |  | `Output_filename` |
| `content_id` | string |  | `Content_ID` |
| `priority` | integer |  | `Priority` |
| `input_start_time` | string |  | `Input_start_time` |
| `input_end_time` | string |  | `Input_end_time` |
| `additional_parameters` | text |  | `Additional_parameters` |

### Inputs

- `Preset_ID` (`string`, required)
- `Job_name` (`string`, optional)
- `Input_filename` (`string`, required)
- `Output_filename` (`string`, required)
- `Content_ID` (`string`, optional)
- `Priority` (`int`, optional)
- `Input_start_time` (`string`, optional)
- `Input_end_time` (`string`, optional)
- `Additional_parameters` (`string`, optional)
- `4Balancer_server` (`string`)

### Outputs

- `Output_file_name` (`string`)
- `Job_name` (`string`)
- `Job_ID` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## EolementheWorkflowManager

- **Display name**: EolementheWorkflowManager
- **Category**: Transcoding
- **Version**: 0.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plug-in provides the ability to run an Eolementhe workflow.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `remote_node` | string |  |  |
| `server_address` | string |  |  |
| `server_port` | integer | `443` (code) | `server port` |
| `polling_frequency` | integer | `10` (code) |  |
| `source` | string |  | `source` |
| `workflow_name` | string |  |  |
| `username` | string |  |  |
| `password` | string |  |  |
| `apikey` | string |  | `API key` |
| `workflow_id` | string |  | `workflow id` |

### Inputs

- `source` (`string`, required)
- `workflow id` (`string`, required)
- `API key` (`string`, required)
- `server port` (`int`, optional)
- `remote node or server address` (`string`)

### Outputs

- `result` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## EpisodeTranscoding

- **Display name**: Episode transcoding
- **Category**: Transcoding
- **Version**: 1.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This is Action plug-ins provides the ability to submit file transformation job to a Telestream Episode engine.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server_node` | string |  | `Server_node_or_address` |
| `server_address` | string |  | `Server_address` |
| `polling_frequency` | integer | `5` (code) | `Polling_frequency` |
| `rpc_port` | integer | `40431` (code) |  |
| `epitask_payload` | text |  | `Epitask_payload` |
| `epitask_filepath` | string |  | `Epitask_filepath` |
| `input_filepath` | string |  | `Input_filepath` |
| `output_filepath` | string |  | `Output_filepath` |
| `demo_mode` | boolean | `false` (code) |  |
| `priority` | integer |  |  |
| `naming` | string |  | `Naming` |
| `job_name` | string |  | `Job_name` |
| `share_io` | string | `no` (code) |  |

### Inputs

- `Polling_frequency` (`int`, optional)
- `Input_filepath` (`string`, required)
- `Output_filepath` (`string`, optional)
- `Naming` (`string`, optional)
- `Job_name` (`string`, optional)
- `Server_address` (`string`, required)
- `Server_node_or_address` (`string`, required)
- `Epitask_filepath` (`string`, required)
- `Epitask_payload` (`string`, optional)
- `Priority` (`int`)
- `RPC_port` (`int`)

### Outputs

- `Output_file_paths` (`array`)
- `Job_ID` (`string`)
- `Workflow_IDs` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## EvertzMediatorOperation

- **Display name**: Evertz Mediator operation
- **Category**: Asset Management
- **Version**: 0.1.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides ability to interact with a Evertz Mediator system.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `mediator_node` | string |  |  |
| `mediator_address` | string |  |  |
| `operation` | string |  |  |
| `placing_id` | string |  | `Placing_id` |
| `mediator_user` | string |  |  |
| `mediator_password` | string |  |  |
| `mediator_status` | string |  | `Mediator_status` |
| `use_ssl` | boolean | `false` |  |

### Inputs

- `Placing_id` (`string`, required)
- `Mediator_status` (`string`, required)
- `Session_ID` (`string`)
- `Mediator_password` (`pwd`)
- `Mediator_user` (`string`)
- `Mediator_node` (`string`)
- `Mediator_address` (`string`)

### Outputs

- `Session_ID` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## ExiftoolXmpTagger

- **Display name**: Exiftool xmp tagger
- **Category**: File Operations
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in can be used to retrieve metadate information about an image, video or audio file using the exiftool application. Also supported is the ability to insert metadata tag in image file (but not videos).

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `media_file_path` | string |  | `Media_file_path` |
| `tagged_media_file_path` | string |  | `Tagged_media_file_path` |
| `operation` | string | `OP_READ` (code) |  |
| `options` | string | `` (code) | `Options` |
| `execution_node` | string |  |  |
| `execution_login` | string |  |  |
| `execution_password` | string |  |  |
| `binary_path` | string | `exiftool` (code) |  |
| `format_result` | text |  |  |
| `tags` | text |  | `Tags` |
| `additional_outputs` | text |  |  |

### Inputs

- `Media_file_path` (`string`, required)
- `Options` (`string`, optional)
- `Tags` (`string` or `hash`, required)
- `Tagged_media_file_path` (`string`, required)

### Outputs

- `Metadata` (`hash`)
- `Tagged_media_file` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## ExitStatus

- **Display name**: Exit status
- **Category**: System
- **Version**: 0.1.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in can be used to set up special exit status messages within the workflow.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `complete_status` | text |  | `Complete_status` |
| `failed_status` | text |  | `Failed_status` |
| `error_status` | text |  | `Error_status` |

### Inputs

- `Complete_status` (`string`, optional)
- `Failed_status` (`string`, optional)
- `Error_status` (`string`, optional)

### Outputs

- `Complete_status_message` (`string`)
- `Failed_status_message` (`string`)
- `Error_status_message` (`string`)
- `Step_information` (`hash`)

## FacebookUploadOperation

- **Display name**: Facebook Video Upload Operation
- **Category**: Integration
- **Version**: 0.3.0 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin is used to perform a resumable video upload via Facebook Graph API.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `object_id` | string |  | `object_id` |
| `access_token` | text |  | `access_token` |
| `video_file` | string |  | `video_file` |
| `folder` | string | `/tmp/` (code) | `folder` |
| `published` | boolean | `true` |  |

### Inputs

- `access_token` (`string`, required)
- `video_file` (`string`, required)
- `object_id` (`string`, required)
- `folder` (`string`, optional)
- `response` (`hash`)
- `upload_id` (`string`)
- `video_id` (`string`)

### Outputs

- `response` (`hash`)
- `upload_id` (`string`)
- `video_id` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## FaspControl

- **Display name**: FASP controller
- **Category**: File Transfer
- **Version**: 0.7.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to control and modify the parameters of running transfers using Aspera's FASP protocol.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `central_node` | string |  | `AsperaCentral Node_or_Address` |
| `central_address` | string |  |  |
| `service_uri` | string |  |  |
| `command` | string |  |  |
| `keep_ongoing_until_end` | boolean |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `node_user` | string |  |  |
| `node_password` | string |  |  |
| `submit_multiple_sessions` | boolean | `false` |  |
| `session_status` | string |  |  |
| `transfer_direction` | string |  |  |
| `transfer_server_address` | string |  |  |
| `transfer_client_address` | string |  |  |
| `transfer_user` | string |  |  |
| `is_shared_rate` | boolean | `false` |  |
| `rate_value` | integer |  | `Rate_Value` |
| `session_ids` | text | `` (code) | `Session_ids` |
| `output_only_failed_files` | boolean | `false` |  |
| `max_results` | integer | `100000` (code) |  |

### Inputs

- `Rate_Value` (`int`, required)
- `Session_ids` (`string`, optional)
- `AsperaCentral Node_or_Address` (`string`, required)
- `Session_ID` (`array` or `string`)
- `Job_ID` (`string`)

### Outputs

- `Session_file_list` (`array`)
- `Sessions_failed_to_cancel` (`array`)
- `Session_status` (`string`)
- `Failed_file_list` (`array`)
- `Transferred_file_list` (`array`)
- `No_of_files_transferred` (`int`)
- `Growing_file_list` (`array`)
- `List_of_Sessions` (`array`)
- `Transfer_Rate_Set` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## FaspTransfer

- **Display name**: FASP transfer
- **Category**: File Transfer
- **Version**: 4.3.6 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides the ability to initiate server-to-server transfers using Aspera's FASP protocol.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `payload` | text |  |  |
| `payload_file` | string |  |  |
| `saved_inputs` | text |  |  |
| `central_address` | string |  |  |
| `service_uri` | string |  |  |
| `central_node` | string |  | `Central_node` |
| `optional_overrides` | text |  |  |
| `lockdown_inputs` | boolean | `0` |  |
| `polling_frequency` | integer | `5` (code) |  |
| `node_user` | string |  | `Node_user` |
| `node_password` | string |  | `Node_password` |
| `use_ssl` | boolean | `false` (code) |  |
| `escape_mode` | string |  |  |
| `split_separator` | string | `Comma` (code) | `Split_separator` |

### Inputs

- `Node_user` (`string`, optional)
- `Node_password` (`string`, optional)
- `Split_separator` (`string`, optional)
- `Central_node` (`string`, required)
- `Timeout` (`int`)
- `FullXMLPayload` (`string`)
- `AsperaCentral_Address` (`string`)

### Outputs

- `Job_ID` (`string`)
- `Transfer_Stats` (`string`)
- `Transferred_File_list` (`array`)
- `Failed_Files_list` (`array`)
- `Transferred_Files_md5` (`hash`)
- `Error_Code` (`string`)
- `Error_Message` (`string`)
- `Average Bandwidth (bps)` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## Faspex5Delivery

- **Display name**: Faspex5 delivery
- **Category**: File Transfer
- **Version**: 0.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides a way to create and send secure file packages through Aspera Faspex5 servers with advanced delivery controls and recipient management.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  | `Name` |
| `title` | string |  | `Title` |
| `comments` | string |  | `Comments` |
| `faspex_sender_user` | string |  | `Faspex_sender_user` |
| `faspex_hostname` | string |  | `Faspex_hostname` |
| `faspex_node` | string |  | `Faspex_node` |
| `notified_on_upload` | string |  | `Notified_on_upload` |
| `notified_on_download` | string |  | `Notified_on_download` |
| `notified_on_receipt` | string |  | `Notified_on_receipt` |
| `expiration_policy` | string |  | `Expiration_policy` |
| `release_policy` | string |  | `Release_policy` |
| `release_at` | string |  | `Release_at` |
| `content_protection_passphrase` | string |  | `Content_protection_passphrase` |
| `payload` | text |  | `Payload` |
| `note` | text |  | `Note` |
| `metadata` | text |  | `Metadata` |
| `recipients` | text |  | `Recipients` |
| `private_recipients` | text |  | `Private_recipients` |
| `paths` | text |  | `Paths` |
| `private_key` | text |  | `Private_key` |
| `client_id` | text |  | `Client_id` |
| `download_limit` | integer |  | `Download_limit` |
| `remote_source_id` | integer |  | `Remote_source_id` |
| `use_remote_source` | boolean | `false` | `Use_remote_source` |
| `ear_enabled` | boolean | `false` | `Ear_enabled` |
| `notify_on_upload` | boolean | `false` | `Notify_on_upload` |
| `notify_on_download` | boolean | `false` | `Notify_on_download` |
| `notify_on_receipt` | boolean | `false` | `Notify_on_receipt` |
| `obfuscation_enabled` | boolean | `false` | `Obfuscation_enabled` |
| `prevent_http_download` | boolean | `false` | `Prevent_http_download` |
| `skip_metadata_validation` | boolean | `false` | `Skip_metadata_validation` |
| `get_package_status_link` | boolean | `false` | `Get_package_status_link` |
| `public_download` | string |  | `Public_download` |

### Inputs

- `Name` (`string`, required)
- `Title` (`string`, required)
- `Comments` (`string`, required)
- `Faspex_sender_user` (`string`, required)
- `Faspex_hostname` (`string`, required)
- `Faspex_node` (`string`, required)
- `Notified_on_upload` (`string`, required)
- `Notified_on_download` (`string`, required)
- `Notified_on_receipt` (`string`, required)
- `Expiration_policy` (`string`, required)
- `Release_policy` (`string`, required)
- `Release_at` (`string`, required)
- `Content_protection_passphrase` (`string`, required)
- `Payload` (`string`, required)
- `Note` (`string`, required)
- `Metadata` (`string`, required)
- `Recipients` (`string`, required)
- `Private_recipients` (`string`, required)
- `Paths` (`string`, required)
- `Private_key` (`string`, required)
- `Client_id` (`string`, required)
- `Download_limit` (`int`, required)
- `Remote_source_id` (`int`, required)
- `Use_remote_source` (`flag`, required)
- `Ear_enabled` (`flag`, required)
- `Notify_on_upload` (`flag`, required)
- `Notify_on_download` (`flag`, required)
- `Notify_on_receipt` (`flag`, required)
- `Obfuscation_enabled` (`flag`, required)
- `Prevent_http_download` (`flag`, required)
- `Skip_metadata_validation` (`flag`, required)
- `Get_package_status_link` (`flag`, required)
- `Public_download` (`string`, required)

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- No `inputs_spec` in plugin class: every template field left blank becomes an input (default behavior).
- No `outputs_spec` in plugin class.

## Faspex5FileProcessing

- **Display name**: Faspex5 file processing
- **Category**: File Transfer
- **Version**: 0.0.6 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin integrates with Faspex5 servers to manage file processing workflows by retrieving lists of files awaiting validation and updating their processing status throughout the validation lifecycle.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `faspex_server_address` | string |  |  |
| `faspex_node` | string |  |  |
| `faspex_user` | string |  |  |
| `faspex_api_client_id` | string |  |  |
| `ssh_private_key` | text |  |  |
| `keep_ongoing` | boolean | `true` |  |
| `polling_frequency` | integer | `10` (code) |  |
| `operation` | string |  |  |
| `file_id` | string |  |  |
| `file_status` | string |  |  |
| `error_message` | string |  |  |
| `max_result` | integer | `20` (code) |  |
| `ssl_client_key_path` | text |  |  |
| `client_key_passphrase` | text |  |  |

### Inputs

- `Faspex_server_address` (`string`)
- `Polling frequency` (`int`)
- `Error_message` (`string`)
- `File_status` (`string`)

### Outputs

- `result_count` (`int`)
- `file_transfer_info` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## Faspex5InboxWatcher

- **Display name**: Faspex5 inbox watcher
- **Category**: Triggers
- **Version**: 0.8.6 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin monitors Faspex5 server mailboxes for incoming packages matching specified criteria and triggers workflows, providing comprehensive package information including metadata, file lists, and transfer specifications.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  | `Name` |
| `comments` | text |  | `Comments` |
| `server` | string |  | `Server` |
| `user` | string |  | `User` |
| `client_id` | string |  | `Client_id` |
| `keep_ongoing` | boolean |  | `Keep_ongoing` |
| `polling_frequency` | integer |  | `Polling_frequency` |
| `early_trigger` | boolean |  | `Early_trigger` |
| `new_only` | boolean |  | `New_only` |
| `run_synchronous` | boolean |  | `Run_synchronous` |
| `mailbox` | string |  | `Mailbox` |
| `query` | string |  | `Query` |
| `faspex_node` | string |  | `Faspex_node` |
| `trigger_type` | string |  | `Trigger_type` |
| `packages_root` | string |  | `Packages_root` |
| `faspex_version` | string |  | `Faspex_version` |
| `ignore_faspex_failures` | boolean | `true` | `Ignore_faspex_failures` |
| `ignore_empty_metadata` | boolean | `false` | `Ignore_empty_metadata` |
| `limit` | integer | `10` | `Limit` |
| `ssl_client_key_path` | text |  | `Ssl_client_key_path` |
| `client_key_passphrase` | text |  | `Client_key_passphrase` |
| `shared_inbox_name` | string |  | `Shared_inbox_name` |
| `private_key` | text |  | `Private_key` |
| `filters` | text |  | `Filters` |
| `destination_root` | text |  | `Destination_root` |
| `get_package_download_link` | text |  | `Get_package_download_link` |
| `package_id` | text |  | `Package_id` |
| `get_transfer_spec` | boolean | `true` | `Get_transfer_spec` |
| `transfer_type` | string | `connect` | `Transfer_type` |

### Inputs

- `Name` (`string`, required)
- `Comments` (`string`, required)
- `Server` (`string`, required)
- `User` (`string`, required)
- `Client_id` (`string`, required)
- `Keep_ongoing` (`flag`, required)
- `Polling_frequency` (`int`, required)
- `Early_trigger` (`flag`, required)
- `New_only` (`flag`, required)
- `Run_synchronous` (`flag`, required)
- `Mailbox` (`string`, required)
- `Query` (`string`, required)
- `Faspex_node` (`string`, required)
- `Trigger_type` (`string`, required)
- `Packages_root` (`string`, required)
- `Faspex_version` (`string`, required)
- `Ignore_faspex_failures` (`flag`, required)
- `Ignore_empty_metadata` (`flag`, required)
- `Limit` (`int`, required)
- `Ssl_client_key_path` (`string`, required)
- `Client_key_passphrase` (`string`, required)
- `Shared_inbox_name` (`string`, required)
- `Private_key` (`string`, required)
- `Filters` (`string`, required)
- `Destination_root` (`string`, required)
- `Get_package_download_link` (`string`, required)
- `Package_id` (`string`, required)
- `Get_transfer_spec` (`flag`, required)
- `Transfer_type` (`string`, required)

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- No `inputs_spec` in plugin class: every template field left blank becomes an input (default behavior).
- No `outputs_spec` in plugin class.

## Faspex5PackageMonitor

- **Display name**: Faspex5 package monitor
- **Category**: Triggers
- **Version**: 0.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: Provides the capability to monitor Faspex 5 package uploads, downloads, and completion status.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `faspex_user` | string |  | `Faspex_user` |
| `server` | string |  | `Faspex_server_address` |
| `private_key` | text |  | `Ssh_private_key` |
| `client_id` | string |  | `Faspex_client_id` |
| `faspex_node` | string |  |  |
| `delivery_id` | string |  | `Delivery_id` |
| `delivery_url` | string |  |  |
| `operation` | string |  |  |
| `polling_frequency` | integer | `10` (code) |  |
| `get_package_download_link` | text |  |  |

### Inputs

- `Faspex_user` (`string`, required)
- `Delivery_id` (`string`, required)
- `Faspex_client_id` (`string`, required)
- `Ssh_private_key` (`string`, required)
- `Faspex_server_address` (`string`, required)

### Outputs

- `Title` (`string`)
- `Id` (`string`)
- `Completed` (`date`)
- `Released` (`date`)
- `Updated` (`date`)
- `Package_status` (`string`)
- `Status` (`string`)
- `State` (`string`)
- `Author_name` (`string`)
- `Author_email` (`string`)
- `Recipient_name` (`string`)
- `Recipient_email` (`string`)
- `Meta_data` (`hash`)
- `Recipient_list` (`hash`)
- `Message` (`string`)
- `EAR Enabled` (`flag`)
- `Package UUID` (`string`)
- `Completed download count` (`int`)
- `Partial download count` (`int`)
- `Active download count` (`int`)
- `Expiration policy` (`string`)
- `Package Download Link` (`string`)
- `Download_details` (`array`)
- `Downloader_list` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## Faspstream

- **Display name**: FASPstream
- **Category**: File Transfer
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to start, monitor and cancel a stream to stream between 2 Aspera transfer servers using faspstream.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `initiating_node` | string |  | `Initiating_node` |
| `initiating_host` | string |  | `Initiating node or address` |
| `initiating_ssh_user_name` | string |  | `Initiating node ssh username` |
| `initiating_ssh_password` | string | `` (code) | `Initiating node ssh password` |
| `initiating_ssh_key_file_path` | string | `` (code) | `Initiating node ssh key path` |
| `initiating_ssh_port` | integer | `33001` (code) | `Initiating node ssh port` |
| `serving_node` | string |  | `Serving_node` |
| `serving_host` | string |  | `Serving node or address` |
| `serving_ssh_user_name` | string |  | `Serving node ssh username` |
| `serving_ssh_password` | string | `` (code) | `Serving node ssh password` |
| `serving_ssh_key_file_path` | string | `` (code) | `Serving node ssh key path` |
| `serving_ssh_port` | integer | `33001` (code) | `Serving node ssh port` |
| `node_api_host` | string | `initiating_node` (code) | `Node API target` |
| `node_api_user_name` | string |  | `Node API user name` |
| `node_api_user_password` | string |  | `Node API user password` |
| `node_api_port` | integer | `9092` (code) | `Node API port` |
| `rate_target` | string |  | `Target rate` |
| `rate_minimum` | string |  | `Minimum rate` |
| `chunk_size` | string | `64k` (code) | `Chunk size` |
| `source_stream_url` | string |  | `Source stream URL` |
| `destination_stream_url` | string |  | `Destination stream URL` |
| `ascp_binary_path` | string | `ascp4` (code) | `Ascp4 binary path` |
| `command_line_options` | string | `` (code) | `Command line options` |
| `transfer_mode` | string | `send` (code) | `Transfer mode` |
| `polling_frequency` | integer | `10` (code) |  |

### Inputs

- `Initiating node or address` (`string`, required)
- `Initiating node ssh username` (`string`, required)
- `Initiating node ssh password` (`string`, optional)
- `Initiating node ssh key path` (`string`, optional)
- `Initiating node ssh port` (`int`, optional)
- `Initiating_node` (`string`, required)
- `Serving node or address` (`string`, required)
- `Serving node ssh username` (`string`, required)
- `Serving node ssh password` (`string`, optional)
- `Serving node ssh key path` (`string`, optional)
- `Serving node ssh port` (`int`, optional)
- `Serving_node` (`string`, required)
- `Node API target` (`string`, optional)
- `Node API user name` (`string`, required)
- `Node API user password` (`string`, required)
- `Node API port` (`int`, optional)
- `Target rate` (`string`, required)
- `Minimum rate` (`string`, required)
- `Source stream URL` (`string`, required)
- `Destination stream URL` (`string`, required)
- `Transfer mode` (`string`, optional)
- `Chunk size` (`string`, optional)
- `Ascp4 binary path` (`string`, optional)
- `Command line options` (`string`, optional)

### Outputs

- `statistics` (`hash`)
- `Transfer mode` (`string`)
- `Node API target` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## FederatedWorkflow

- **Display name**: Federated workflow
- **Category**: System
- **Version**: 0.6.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This plug-in is used to launch workflows on a remote orchestrator instance and get the ID and output(s) or just get the ID and not wait for the output(s) of the remote workflow

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | text |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `remote_node` | string |  |  |
| `remote_address` | string |  | `"Remote_address".freeze` |
| `remote_port` | string |  | `"Remote_port".freeze` |
| `remote_user` | string |  | `"Remote_user".freeze` |
| `remote_password` | string |  | `"Remote_password".freeze` |
| `remote_workflow_id` | integer |  |  |
| `remote_workflow_name` | text |  | `Remote_workflow_name` |
| `workflow_outputs` | text |  |  |
| `workflow_parameters` | text |  | `"Work_order_parameters".freeze` |
| `higher_priority` | string | `false` (code) |  |
| `preemptive_level` | integer |  |  |
| `priority` | integer |  |  |
| `check_for_status_in` | integer |  |  |
| `reporting_increment` | integer | `5` (code) |  |
| `use_ssl` | boolean |  |  |
| `identify_by_name` | boolean |  |  |
| `work_order_name` | string |  | `Work_order_name` |
| `web_root` | string | `"/aspera/orchestrator".freeze` (code) |  |
| `return_all_outputs` | boolean |  |  |
| `no_webroot` | boolean |  |  |
| `report_status_details` | boolean | `false` (code) | `Report_status_details` |
| `remote_workflow_portable_id` | string |  | `Remote_workflow_portable_id` |
| `identify_by_portable_id` | boolean | `false` |  |
| `report_status_details_top_level` | boolean |  |  |

### Inputs

- `"Remote_user".freeze` (`string`, required)
- `Work_order_name` (`string`, optional)
- `"Remote_password".freeze` (`string`, required)
- `Report_status_details` (`flag`, optional)
- `Remote_workflow_name` (`string`, required)
- `Remote_workflow_portable_id` (`string`, required)
- `"Remote_address".freeze` (`string`, required)
- `"Remote_port".freeze` (`string` or `int`, optional)
- `"Work_order_parameters".freeze` (`string` or `hash`, required)
- `"Remote_workflow_id".freeze` (`int`)
- `"Remote_node".freeze` (`string`)

### Outputs

- `"WorkOrder_ID".freeze` (`int`)
- `"WorkOrder_Status".freeze` (`string`)
- `"Execution_address".freeze` (`string`)
- `"Execution_node".freeze` (`string`)
- `"WorkOrder_Outputs".freeze` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## FfmpgTranscoding

- **Display name**: FFMPEG transcoding
- **Category**: Transcoding
- **Version**: 0.6.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides the ability to execute file transcoding operations using the FFMPEG toolset on remote nodes.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execution_node` | string |  | `Execution_node` |
| `execution_login` | string |  | `Execution_login` |
| `execution_password` | string |  | `Execution_password` |
| `binary_path` | string | `ffmpeg` (code) | `Binary_path` |
| `input_file_path` | string |  | `Input_file_path` |
| `output_file_path` | string |  | `Output_file_path` |
| `force_file_format` | string |  |  |
| `options` | text | `` (code) | `Options` |
| `overwrite_output` | boolean | `false` (code) | `Overwrite_output` |
| `post_path_parameters` | text | `` (code) | `Post_path_parameters` |
| `is_manual_command` | boolean | `false` |  |
| `manual_command` | text |  | `Manual_command` |
| `execution_on_windoz` | boolean | `false` (code) | `Execution_on_windoz` |

### Inputs

- `Manual_command` (`string`, required)
- `Execution_node` (`string`, required)
- `Binary_path` (`string`, optional)
- `Input_file_path` (`string`, required)
- `Output_file_path` (`string`, required)
- `Options` (`string`, optional)
- `Post_path_parameters` (`string`, optional)
- `Execution_login` (`string`, optional)
- `Execution_password` (`string`, optional)
- `Overwrite_output` (`flag`, optional)
- `Execution_on_windoz` (`flag`, optional)

### Outputs

- `transformation_report` (`string`)
- `Result_file_path` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## FfprobeInfo

- **Display name**: FFProbe Information
- **Category**: File Operations
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to submit a file to FFProbe to grab media properties and technical Metadata

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execution_node` | string |  | `Execution_node` |
| `execution_login` | string |  | `Execution_login` |
| `execution_password` | string |  | `Execution_password` |
| `binary_path` | string | `ffprobe` (code) | `Binary_path` |
| `input_file_path` | string |  | `Input_file_path` |
| `report_file_path` | string |  | `Report_file_path` |
| `options` | string | `` (code) | `Options` |

### Inputs

- `Input_file_path` (`string`, required)
- `Report_file_path` (`string`, optional)
- `Options` (`string`, optional)
- `Execution_node` (`string`, required)
- `Binary_path` (`string`, optional)
- `Execution_login` (`string`, optional)
- `Execution_password` (`string`, optional)

### Outputs

- `Report_File_Path` (`string`)
- `Report` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## FileArchivingOperation

- **Display name**: File archiving operation
- **Category**: File Operations
- **Version**: 0.4.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides the ability to execute file archiving operations on both Orchestrator locally-mounted file systems and remote Linux systems via SSH.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `sources` | string |  | `Sources` |
| `target` | string |  | `target` |
| `fail_on_incomplete` | boolean |  |  |
| `base` | string |  | `base` |
| `chmod` | string |  | `Chmod` |
| `uid` | string |  | `Uid` |
| `guid` | string |  | `Guid` |
| `recursive` | boolean | `false` | `Recursive` |
| `cmd_line_options` | text |  | `Cmd_line_options` |
| `use_remote` | boolean | `false` |  |
| `remote_node` | string |  | `remote_node` |
| `remote_node_user` | string |  |  |
| `remote_node_password` | string |  |  |
| `remote_node_port` | integer | `22` (code) |  |
| `remote_node_ip_address` | string |  |  |
| `runtime_remote_node` | string |  |  |
| `is_base_dir` | boolean |  |  |
| `is_target_dir` | boolean |  |  |

### Inputs

- `remote_node` (`string`, required)
- `target` (`string`, optional)
- `Sources` (`string`, required)
- `base` (`string`, optional)
- `Cmd_line_options` (`string`, optional)
- `Chmod` (`string`, optional)
- `Uid` (`string`, optional)
- `Guid` (`string`, optional)
- `Recursive` (`flag`, optional)
- `runtime_remote_node` (`string`)
- `remote_node_ip_address` (`string`)
- `remote_node_user` (`string`)
- `remote_node_password` (`string`)
- `remote_node_port` (`int`)

### Outputs

- `Command` (`string`)
- `File_list` (`array`)
- `Failed_list` (`array`)
- `target_file` (`string`)
- `Exit_Code` (`int`)
- `Operation_Output` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## FileGenerator

- **Display name**: File generator
- **Category**: File Operations
- **Version**: 0.5.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in is used to create a file using dynamic content provided from parameters and/or the output from previous steps in the workflow. Although it can generate any text file, it is primarily used to generate XML files to be used by other steps or other applications. The user defines the template to be used, the variable content required and variable names, and maps the variable inputs.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `file_body_template` | text |  |  |
| `file_body_path` | string |  | `File_body_path` |
| `target_file_path` | string |  | `Target_file_path` |
| `return_file_as_output` | boolean |  |  |
| `required_inputs` | text |  |  |
| `optional_inputs` | text |  |  |
| `suppress_linefeeds` | boolean |  |  |
| `append` | boolean | `false` (code) |  |

### Inputs

- `Target_file_path` (`string`, optional)
- `File_body_path` (`string`, required)

### Outputs

- `Generated_file_path` (`string`)
- `Generated_file_content` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## FileInfo

- **Display name**: File information
- **Category**: File Operations
- **Version**: 0.2.1 (requires Orchestrator 4.1.6 or later)
- **Description**: Extracts multiple information about a local file, given its full path.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `file_path` | string |  | `File_path` |
| `fail_if_not_exists` | boolean | `false` (code) | `Fail_if_not_exists` |
| `array_mode` | boolean |  |  |

### Inputs

- `File_path` (`string` or `array`, required)
- `Fail_if_not_exists` (`flag`, optional)

### Outputs

- `folder?` (`hash` or `flag`)
- `symlink?` (`hash` or `flag`)
- `naked_name` (`hash` or `string`)
- `parent` (`hash` or `string`)
- `extension` (`hash` or `string`)
- `atime` (`string`)
- `unix_atime` (`hash` or `int`)
- `parent_name` (`hash` or `string`)
- `mtime` (`string`)
- `unix_mtime` (`hash` or `int`)
- `file_name` (`hash` or `string`)
- `file_size` (`hash` or `string`)
- `ctime` (`string`)
- `unix_ctime` (`hash` or `int`)
- `exists?` (`hash` or `flag`)
- `file_size_in_KB` (`hash` or `int`)
- `file_size_in_bytes` (`hash` or `int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## FileJournalLogEntry

- **Display name**: File journal log entry
- **Category**: Other Utilities
- **Version**: 0.4.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides the ability to log file states in the Orchestrator file journal.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `file` | string |  |  |
| `file_path` | string |  |  |
| `package` | string |  |  |
| `step_name` | string |  |  |
| `processing_status` | string |  |  |
| `event` | string | `` (code) |  |
| `processing_timeout` | integer |  |  |
| `journal_book` | string |  |  |
| `new_file` | boolean | `false` (code) | `New_file` |
| `new_package` | boolean | `false` (code) | `New_package` |
| `milestone` | integer | `0` (code) | `Milestone` |
| `journal_to_file` | boolean | `false` (code) |  |
| `journal_file_path` | string | `"` (code) |  |
| `file_entry_format` | string | `event[time],event[package],event[file],event[status],event[event]` (code) |  |
| `max_file_count` | integer | `5` (code) |  |
| `max_file_size_in_mb` | integer | `5` (code) |  |
| `write_to_journal` | boolean | `true` |  |

### Inputs

- `New_file` (`flag`, optional)
- `New_package` (`flag`, optional)
- `Milestone` (`int`, optional)
- `File_path` (`string`)
- `package` (`string`)
- `package_ID` (`string`)
- `file` (`string`)
- `File_processing_status` (`string`)
- `file_ID` (`int`)
- `Journal Book` (`string`)

### Outputs

- `actual_package_ID` (`string`)
- `actual_file` (`string`)
- `actual_path` (`string`)
- `journal_file_ID` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## Filter

- **Display name**: Filter
- **Category**: System
- **Version**: 0.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in allows conditional execution of a step by evaluating a custom Ruby expression at run-time. The result determines whether the step completes successfully or fails.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `command` | text |  |  |
| `mandatory_inputs` | text |  |  |
| `optional_inputs` | text |  |  |
| `filter_outputs` | text |  |  |

### Inputs

- None found in source.

### Outputs

- `FilterResult` (`flag`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Outputs are partly defined by template fields: see the template attributes.

## FlicsTranscoding

- **Display name**: Flics transcoding
- **Category**: Transcoding
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to submit and monitor a file transcoding job to a Flics server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `address` | string |  |  |
| `use_ssl` | boolean |  |  |
| `username` | string |  |  |
| `password` | string |  |  |
| `use_advanced_mode` | boolean |  |  |
| `custom_task` | text |  |  |
| `source_file_name` | string |  |  |
| `source_storage_id` | string |  |  |
| `template_id` | string |  |  |
| `port` | integer |  |  |
| `title` | string |  |  |
| `tags` | string | `local` (code) |  |
| `polling_frequency` | integer | `10` (code) |  |

### Inputs

- None found in source.

### Outputs

- `destination_files` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## FlipFactoryTransformation

- **Display name**: FlipFactory transcoding
- **Category**: Transcoding
- **Version**: 1.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This is Action plug-ins provides the ability to submit file transformation job to a Telestream FlipFactory server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `message` | text | `"<?xml version='1.0' encoding='UTF-8'?><message uuid=''><envelope subject='FlipFactory default message'><to> <account username='<%=` (code) |  |
| `saved_inputs` | text |  |  |
| `server_url` | string |  |  |
| `server_node` | string |  |  |
| `polling_frequency` | integer |  |  |

### Inputs

- `message_override` (`string`)
- `user_password` (`string`)
- `FlipFactoryNode` (`string`)
- `FlipFactoryServer_url` (`string`)

### Outputs

- `output_directory` (`string`)
- `output_files_array` (`array`)
- `total_processed` (`int`)
- `first_error_msg` (`string`)
- `first_error_type` (`string`)
- `error_messages` (`array`)
- `error_types` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## FrameioOperation

- **Display name**: Frameio Operation
- **Category**: Integration
- **Version**: 0.3.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to perform operations on Frame.io.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `token` | text |  | `Token` |
| `account_id` | string |  | `Account_id` |
| `team_id` | string |  | `Team_id` |
| `assets_id` | string |  | `Assets_id` |
| `asset_type` | string |  |  |
| `file_type` | string |  |  |
| `file_size` | string |  |  |
| `asset_name` | string |  | `Asset_name` |
| `upload_urls_list` | text |  |  |
| `local_file_path` | string |  | `Local_file_path` |
| `content_type` | string |  | `Content_type` |
| `verify_ssl` | boolean | `true` | `Verify_ssl` |
| `api_version` | string | `v2` | `Api_version` |
| `auth_type` | string | `legacy_token` | `Auth_type` |
| `client_id` | string |  |  |

### Inputs

- `Verify_ssl` (`flag`, required)
- `Api_version` (`string`, required)
- `Auth_type` (`string`, required)
- `Token` (`string`, required)
- `Account_id` (`string`, required)
- `Team_id` (`string`, required)
- `Assets_id` (`string`, required)
- `Asset_name` (`string`, required)
- `Local_file_path` (`string`, required)
- `Content_type` (`string`, required)
- `asset_type` (`string`)
- `file_type` (`string`)
- `file_size` (`string`)
- `local_file_path` (`string`)
- `upload_urls_list` (`array`)

### Outputs

- `Error_Message` (`string`)
- `Result` (`hash`)
- `Account_Id` (`string`)
- `Team_List` (`array`)
- `Project_List` (`array`)
- `Assets_List` (`array`)
- `Upload_Urls` (`array`)
- `Number_of_threads_successfully_executed` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## FtpFolderTrigger

- **Display name**: FTP Folder Trigger
- **Category**: Triggers
- **Version**: 0.1.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action provides the ability to detect folders on a remote node via the FTP protocol.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `remote_node` | string |  |  |
| `remote_server` | string |  | `remote_server` |
| `remote_server_port` | integer | `21` (code) | `remote_server_port` |
| `remote_user` | string |  |  |
| `remote_password` | string |  |  |
| `passive` | boolean |  |  |
| `polling_frequency` | integer |  |  |
| `remote_directory` | string |  | `remote_directory` |
| `trigger_type` | string |  |  |
| `ftp_timeout` | integer | `50` (code) | `Ftp_timeout` |
| `recursion_depth` | integer | `0` (code) |  |
| `use_ftp_glob` | boolean | `true` (code) |  |
| `disable_dns_lookup` | boolean | `false` (code) |  |
| `trigger_foldername_pattern` | string | `` (code) | `Trigger_foldername_pattern` |
| `check_once` | boolean |  |  |
| `check_folders_recursively` | boolean | `false` (code) | `check_folders_recursively` |
| `allow_multiple` | boolean |  |  |
| `max_folder_returned` | integer |  |  |

### Inputs

- `remote_server` (`string`, required)
- `remote_server_port` (`int`, optional)
- `Ftp_timeout` (`int`, optional)
- `remote_directory` (`string`, optional)
- `check_folders_recursively` (`flag`, optional)
- `Trigger_foldername_pattern` (`string`, optional)
- `remote_user` (`string`)
- `remote_password` (`string`)

### Outputs

- `trigger_folder` (`string`)
- `trigger_folder_array` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## FtpTransfer

- **Display name**: FTP transfer
- **Category**: File Transfer
- **Version**: 1.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides a configurable interface to a remote FTP server. It supports sending, retrieving and deleting files within server directories. Username and password authentication are supported when required by the server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `remote_server` | string |  |  |
| `remote_user` | string |  |  |
| `remote_password` | string |  |  |
| `proxy_server` | string |  |  |
| `proxy_user` | string |  |  |
| `proxy_password` | string |  |  |
| `remote_directory` | string |  |  |
| `action` | string |  |  |
| `local_directory` | string |  |  |
| `source_filename` | string |  |  |
| `target_filename` | string |  |  |
| `binary` | boolean | `true` |  |
| `remove_after_transfer` | boolean |  |  |
| `blocksize` | integer |  |  |
| `reporting_increment` | integer | `5` (code) |  |
| `remote_node` | string |  |  |
| `remote_server_port` | integer | `21` (code) |  |
| `passive_mode` | boolean | `true` |  |
| `outputs_as_array` | boolean | `false` |  |
| `upload_folder` | boolean | `false` |  |
| `allow_download_folder` | boolean | `false` |  |
| `validate_file_sizes` | boolean | `false` |  |
| `do_archive` | boolean | `false` | `Do_archive` |
| `archive_directory` | string |  | `Archive_directory` |
| `show_true_byte_count` | boolean | `false` |  |
| `ignore_listing` | boolean | `false` |  |
| `ftp_debug` | boolean | `true` |  |
| `ignore_invalid_files` | boolean | `false` |  |

### Inputs

- `Do_archive` (`flag`, optional)
- `Archive_directory` (`string`, optional)
- `target_file` (`array` or `string`)
- `size` (`int`)
- `local_file_path` (`array` or `string`)
- `remote_file_path` (`array` or `string`)
- `modification_times` (`array` or `string`)
- `file_size_validation` (`flag`)
- `size_validation_failure_files` (`array`)
- `invalid_files` (`array`)
- `remote_server_port` (`int`)
- `local_directory` (`string`)
- `remote_directory` (`string`)
- `remote_password` (`string`)
- `target_filename` (`string`)
- `binary` (`flag`)
- `passive_mode` (`flag`)
- `remove_after_transfer` (`flag`)
- `validate_file_size` (`flag`)
- `upload_folder_recursively` (`flag`)

### Outputs

- `target_file` (`array` or `string`)
- `size` (`int`)
- `local_file_path` (`array` or `string`)
- `remote_file_path` (`array` or `string`)
- `modification_times` (`array` or `string`)
- `file_size_validation` (`flag`)
- `size_validation_failure_files` (`array`)
- `invalid_files` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## FtpTrigger

- **Display name**: FTP Trigger
- **Category**: Triggers
- **Version**: 2.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action enables the detection of files on a remote node via the FTP protocol.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `remote_node` | string |  |  |
| `remote_server` | string |  |  |
| `remote_server_port` | integer | `21` (code) |  |
| `remote_user` | string |  |  |
| `remote_password` | string |  |  |
| `passive` | boolean |  |  |
| `polling_frequency` | integer |  |  |
| `remote_directory` | string |  |  |
| `trigger_filename_pattern` | string |  |  |
| `partial_file` | boolean |  |  |
| `max_file_returned` | integer |  |  |
| `import_directory` | string |  |  |
| `import_base` | string |  |  |
| `binary` | boolean |  |  |
| `remove_after_transfer` | boolean |  |  |
| `blocksize` | integer |  |  |
| `reporting_increment` | integer | `5` (code) |  |
| `allow_multiple` | boolean |  |  |
| `trigger_type` | string |  |  |
| `move_after_trigger` | string |  | `Move_after_trigger` |
| `check_folders_recursively` | boolean | `false` (code) |  |
| `check_once` | boolean |  |  |
| `ftp_timeout` | integer | `50` (code) | `Ftp_timeout` |
| `ignore_zero_bytes_files` | boolean | `false` | `Ignore_zero_bytes_files` |
| `ignore_folders` | boolean | `false` | `Ignore_folders` |
| `move_after_trigger_suffix` | string |  | `Move_after_trigger_suffix` |
| `move_after_trigger_default_suffix` | boolean | `false` (code) | `Move_after_trigger_default_suffix` |
| `use_ftp_glob` | boolean | `true` (code) |  |
| `recursion_depth` | integer | `0` (code) |  |
| `disable_dns_lookup` | boolean | `false` (code) |  |

### Inputs

- `Move_after_trigger` (`string`, optional)
- `Ftp_timeout` (`int`, optional)
- `Ignore_zero_bytes_files` (`flag`, optional)
- `Ignore_folders` (`flag`, optional)
- `Move_after_trigger_suffix` (`string`, optional)
- `Move_after_trigger_default_suffix` (`flag`, optional)
- `remote_server_port` (`int`)
- `remote_password` (`string`)
- `remote_directory` (`string`)
- `file_name_pattern` (`string`)
- `import_directory` (`string`)
- `check_folders_recursively` (`flag`)
- `persistence_scope` (`string`)

### Outputs

- `trigger_filename` (`string`)
- `archived_filename` (`string`)
- `trigger_file_size` (`int`)
- `trigger_files_array` (`array`)
- `archived_files_array` (`array`)
- `trigger_files_array_size` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## FtpsTransfer

- **Display name**: Ftps transfer
- **Category**: File Transfer
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin can be used to perform secure file transfer operations on FTPS servers with SSL/TLS encryption and file renaming support.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `remote_node` | string |  |  |
| `remote_server_port` | string | `21` (code) |  |
| `remote_server` | string |  |  |
| `remote_user` | string |  | `remote_user` |
| `remote_password` | string |  | `remote_password` |
| `remote_directory` | string |  | `remote_directory` |
| `action` | string |  |  |
| `local_directory` | string |  | `local_directory` |
| `source_filename` | string |  |  |
| `target_filename` | string |  | `target_filename` |
| `remove_after_transfer` | boolean |  | `Remove_after_transfer` |

### Inputs

- `remote_user` (`string`, required)
- `remote_password` (`string`, required)
- `remote_directory` (`string`, optional)
- `local_directory` (`string`, optional)
- `target_filename` (`string`, optional)
- `Remove_after_transfer` (`flag`, required)

### Outputs

- `files_list` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## Funnelin

- **Display name**: Funnel-in
- **Category**: System
- **Version**: 1.1.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin collects and aggregates outputs from parallel executions initiated by Array Fanout, converging multiple parallel processing threads back into a unified workflow.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `synch_filter` | integer |  |  |
| `name` | string |  |  |
| `return_status` | boolean |  |  |
| `comments` | text |  |  |
| `fail_if_failures` | boolean | `false` (code) | `Fail_if_failures` |
| `funneled_as` | string |  |  |
| `funneled_inputs` | text |  |  |
| `funnel_type` | string |  |  |
| `funnel_variable` | string |  |  |

### Inputs

- `Fail_if_failures` (`flag`, optional)
- `<funnel_variable>` (`<funnel_type>`)

### Outputs

- `Hash_by_state_id` (`hash`)
- `<funnel_variable>` (`<funnel_type>`)
- `Status_by_state_id` (`hash`)
- `Status_hash` (`hash`)
- `#{inp}_hash` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- A name in angle brackets (`<attribute>`) is the value of that template attribute.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## FxpTransfer

- **Display name**: FXP Transfer
- **Category**: File Transfer
- **Version**: 0.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action provides the ability to move files using the FXP protocol.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `remote_server` | string |  |  |
| `remote_server_port` | integer | `21` (code) |  |
| `remote_user` | string |  |  |
| `remote_password` | string |  |  |
| `origin_server` | string |  |  |
| `origin_server_port` | integer | `21` (code) |  |
| `origin_user` | string |  |  |
| `origin_password` | string |  |  |
| `remote_directory` | string | `/` (code) |  |
| `origin_file_path` | string |  |  |
| `target_file_path` | string | `` (code) |  |
| `handshake_protocol` | string | `SSCN` (code) |  |
| `remote_file_name` | string |  |  |

### Inputs

- `FXP debug flag` (`flag`)

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## GoogleCloudstorageOperation

- **Display name**: Google Cloud Storage Operation
- **Category**: Integration
- **Version**: 0.1.1 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to perform an action on the Google Cloud Storage service.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `credentials_filepath` | string |  | `Credentials_filepath` |
| `project_id` | string |  | `Project_id` |
| `bucket_name` | string |  | `Bucket_name` |
| `subscription_name` | string |  |  |
| `local_filepath` | string |  | `Local_filepath` |
| `remote_filepath` | string |  | `Remote_filepath` |

### Inputs

- `Credentials_filepath` (`string`, required)
- `Project_id` (`string`, required)
- `Bucket_name` (`string`, required)
- `Local_filepath` (`string`, required)
- `Remote_filepath` (`string`, required)
- `Operation` (`string`)

### Outputs

- `Error_message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## GooglePubsubOperation

- **Display name**: Google Pubsub Operation
- **Category**: Integration
- **Version**: 0.1.1 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to perform an action on the Google Pub/Sub service.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `credentials_filepath` | string |  | `Credentials_filepath` |
| `project_id` | string |  | `Project_id` |
| `topic_name` | string |  | `Topic_name` |
| `subscription_name` | string |  | `Subscription_name` |
| `message_body` | text |  | `Message_body` |
| `max_number_of_messages` | integer | `1` (code) | `Max_number_of_messages` |
| `keep_ongoing` | boolean |  |  |
| `polling_frequency` | integer | `5` (code) |  |

### Inputs

- `Credentials_filepath` (`string`, required)
- `Project_id` (`string`, required)
- `Topic_name` (`string`, required)
- `Subscription_name` (`string`, required)
- `Message_body` (`string`, required)
- `Max_number_of_messages` (`int`, optional)
- `Operation` (`string`)

### Outputs

- `Messages` (`array`)
- `Error_message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## HandbrakeTranscoding

- **Display name**: HandBrake transcoding
- **Category**: Transcoding
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to submit and control a file transcoding operation using the HandBrake toolset.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execution_node` | string |  | `Execution_node` |
| `execution_login` | string |  | `Execution_login` |
| `execution_password` | string |  | `Execution_password` |
| `binary_path` | string |  | `Binary_path` |
| `input_file_path` | string |  | `Input_file_path` |
| `output_file_path` | string |  | `Output_file_path` |
| `options` | text | `` (code) |  |

### Inputs

- `Input_file_path` (`string`, required)
- `Output_file_path` (`string`, required)
- `Binary_path` (`string`, required)
- `Execution_node` (`string`, optional)
- `Execution_login` (`string`, optional)
- `Execution_password` (`string`, optional)
- `Result_file_path` (`string`)
- `transformation_report` (`string`)

### Outputs

- `Result_file_path` (`string`)
- `transformation_report` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## HelloWorld

- **Display name**: Hello world
- **Category**: Other Utilities
- **Version**: 1.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This is a reference implementation for a simple Action plugin illustrating the API.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `prompt` | text | `Hello World` (code) |  |
| `tempo` | integer | `2` (code) |  |

### Inputs

- `prompt_override` (`string`)
- `tempo` (`int`)

### Outputs

- `message` (`string`)
- `Step_information` (`hash`)

## HttpTransfer

- **Display name**: HTTP Transfer
- **Category**: File Transfer
- **Version**: 0.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action provides the ability to upload, download and delete files from a remote host using HTTP or HTTPS (Hypertext Transfer Protocol or Hypertext Transfer Protocol over SSL).

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  | `Operation` |
| `remote_node` | string |  |  |
| `remote_address` | string |  |  |
| `remote_port` | string |  | `Remote_port` |
| `remote_user` | string |  | `Remote_user` |
| `remote_password` | string |  |  |
| `remote_key_location` | string |  | `Remote_key_location` |
| `local_path` | string |  | `Local_path` |
| `remote_path` | string |  | `Remote_path` |
| `remove_source_file` | boolean | `false` (code) |  |
| `reporting_increment` | integer | `5` (code) |  |
| `blocksize` | integer |  |  |
| `fail_if_http_error` | boolean | `false` |  |

### Inputs

- `Operation` (`string`, required)
- `Remote_path` (`string`, required)
- `Local_path` (`string`, required)
- `Remote_user` (`string`, optional)
- `Remote_port` (`string`, optional)
- `Remote_key_location` (`string`, optional)
- `local_path` (`string`)
- `Remote_node_or_address` (`string`)
- `Remote_password` (`string`)

### Outputs

- `Transferred_files` (`array`)
- `Transferred_bytes` (`int`)
- `Status details` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## HybrikTranscoder

- **Display name**: Hybrik Transcoder
- **Category**: Transcoding
- **Version**: 0.1.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This Action plug-in provides the ability to submit a transcoding job to the Hybrik transcoder

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `oapi_key` | string |  | `Oapi_key` |
| `oapi_secret` | string |  | `Oapi_secret` |
| `username` | string |  | `Username` |
| `password` | string |  | `Password` |
| `endpoint` | string |  | `Endpoint` |
| `json_payload` | text |  | `Json_payload` |
| `polling_frequency` | integer | `5` (code) |  |

### Inputs

- `Oapi_key` (`string`, required)
- `Oapi_secret` (`string`, required)
- `Username` (`string`, required)
- `Password` (`string`, required)
- `Endpoint` (`string`, required)
- `Json_payload` (`string`, required)

### Outputs

- `result` (`string`)
- `result_json` (`string`)
- `job_id` (`string`)
- `error_message` (`string`)
- `Step_information` (`hash`)

## IbmMqIntegration

- **Display name**: Ibm mq integration
- **Category**: Integration
- **Version**: 0.5.4 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin is used to send/receive MQ messages to/from an IBM MQ system.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `mq_ip_address` | string |  | `Mq_ip_address` |
| `mq_port` | string | `1414` (code) | `Mq_port` |
| `mq_channel_name` | string |  | `Mq_channel_name` |
| `mq_queue_name` | string |  | `Mq_queue_name` |
| `mq_queue_manager` | string |  | `Mq_queue_manager` |
| `mq_queue_content_file` | string |  |  |
| `log_file_name` | string |  |  |
| `operation_type` | string |  |  |
| `polling_frequency` | integer | `5` (code) | `Polling_frequency` |
| `execution_node` | string |  | `Execution_node` |
| `put_body` | text |  | `Put_body` |
| `keep_ongoing` | boolean | `false` (code) | `Keep_ongoing` |
| `show_output_as_json` | boolean | `false` |  |
| `mq_user_name` | string |  | `Mq_user_name` |
| `mq_user_password` | string |  | `Mq_user_password` |
| `mq_ssl` | boolean | `false` |  |
| `mq_cipher` | string |  | `Mq_cipher` |
| `mq_trust_store` | string |  | `Mq_trust_store` |
| `mq_trust_store_password` | string | `` (code) | `Mq_trust_store_password` |

### Inputs

- `Polling_frequency` (`int`, optional)
- `Mq_port` (`string`, optional)
- `Mq_channel_name` (`string`, required)
- `Mq_queue_name` (`string`, required)
- `Mq_queue_manager` (`string`, required)
- `Mq_user_name` (`string`, optional)
- `Mq_user_password` (`string`, optional)
- `Put_body` (`string`, required)
- `Keep_ongoing` (`flag`, optional)
- `Mq_ip_address` (`string`, required)
- `Execution_node` (`string`, required)
- `Mq_cipher` (`string`, required)
- `Mq_trust_store` (`string`, required)
- `Mq_trust_store_password` (`string`, optional)

### Outputs

- `Message_Received` (`string`)
- `Message_Id` (`string`)
- `Message_Received_JSON` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## IbmMqMftTransfer

- **Display name**: Ibm mq mft transfer
- **Category**: Integration
- **Version**: 0.5.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin is used to send a file via IBM MQ MFT.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `mq_ip_address` | string |  | `Mq_ip_address` |
| `mq_port` | string | `1414` (code) | `Mq_port` |
| `mq_channel_name` | string |  | `Mq_channel_name` |
| `mq_queue_name` | string |  | `Mq_queue_name` |
| `mq_queue_manager` | string |  | `Mq_queue_manager` |
| `mq_queue_content_file` | string |  |  |
| `log_file_name` | string |  |  |
| `operation_type` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `mq_message_id` | string |  | `Mq_message_id` |
| `mq_agent_name` | string |  | `Mq_agent_name` |
| `execution_node` | string |  | `Execution_node` |
| `put_body` | mediumtext |  | `Put_body` |
| `keep_ongoing` | boolean | `false` (code) |  |
| `subscription_queue_name` | string |  | `Subscription_queue_name` |
| `subscription_name` | string |  | `Subscription_name` |
| `mq_user_name` | string |  | `Mq_user_name` |
| `mq_user_password` | string |  | `Mq_user_password` |
| `mq_ssl` | boolean | `false` |  |
| `mq_cipher` | string |  | `Mq_cipher` |
| `mq_trust_store` | string |  | `Mq_trust_store` |
| `mq_trust_store_password` | string | `` (code) | `Mq_trust_store_password` |

### Inputs

- `Mq_port` (`string`, optional)
- `Mq_channel_name` (`string`, required)
- `Mq_queue_name` (`string`, required)
- `Mq_queue_manager` (`string`, required)
- `Mq_user_name` (`string`, optional)
- `Mq_user_password` (`string`, optional)
- `Put_body` (`string`, required)
- `Subscription_queue_name` (`string`, required)
- `Mq_agent_name` (`string`, required)
- `Subscription_name` (`string`, required)
- `Mq_message_id` (`string`, required)
- `Mq_ip_address` (`string`, required)
- `Execution_node` (`string`, required)
- `Mq_cipher` (`string`, required)
- `Mq_trust_store` (`string`, required)
- `Mq_trust_store_password` (`string`, optional)

### Outputs

- `Message_Received` (`string`)
- `Transfer_Message_Id` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## IcapVirusScan

- **Display name**: ICAP virus scan
- **Category**: Virus Scan
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in communicates with an ICAP enabled virus scanner engine to quarantine infected files.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `scan_directory` | string |  |  |
| `file_pattern` | string |  |  |
| `max_file_size` | integer |  |  |
| `on_max_size_action` | string |  |  |
| `base_dir` | string |  |  |
| `use_regex_matching` | boolean |  |  |
| `keep_ongoing` | boolean |  |  |
| `cut_infected_files` | boolean |  |  |
| `clean_directory` | string |  |  |
| `quarantine_directory` | string |  |  |
| `infection_manifest_directory` | string |  |  |
| `scan_frequency` | integer | `5` (code) |  |
| `parallel_scans` | integer | `12` (code) |  |
| `partial_file` | boolean |  |  |
| `icap_server_address` | string |  |  |
| `client_command` | string |  |  |
| `result_parse_command` | text |  |  |
| `list_infection_command` | text |  |  |
| `scan_suffix` | string | `.scanning` (code) |  |

### Inputs

- `File_list` (`string`)

### Outputs

- `Clean_file_list` (`array`)
- `Quarantined_file_list` (`array`)
- `Infection_manifest` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## Imagemagick

- **Display name**: Imagemagick
- **Category**: File Transformations
- **Version**: 0.1.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in can be used to retrieve media information about an image or apply transformation to that image using the popular imagemagick application.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `media_file_path` | string |  |  |
| `options` | text |  |  |
| `command_arguments` | text |  |  |
| `command` | string |  |  |
| `script` | text |  |  |
| `execution_node` | string |  |  |
| `execution_login` | string |  |  |
| `execution_password` | string |  |  |
| `binary_path` | string | `` (code) |  |

### Inputs

- `Media_file_path` (`string`)
- `Options` (`string`)
- `Command_arguments` (`string`)
- `Imagemagick_node` (`string`)
- `Execution_login` (`string`)
- `Execution_password` (`string`)
- `Binaries_folder_path` (`string`)

### Outputs

- `Image_info` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## InfluxdbOperation

- **Display name**: InfluxDB
- **Category**: Integration
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides the ability to interact with InfluxDB

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `url` | string |  | `Url` |
| `db_name` | string |  | `Db_name` |
| `user_name` | string |  | `User_name` |
| `password` | string |  | `Password` |
| `query` | text |  | `Query` |
| `data` | text |  | `Data` |
| `chunk_size` | integer |  | `Chunk_size` |
| `precision` | string |  | `Precision` |
| `consistency` | string |  | `Consistency` |
| `retention_policy` | string |  | `Retention_policy` |

### Inputs

- `Db_name` (`string`, required)
- `Url` (`string`, required)
- `Precision` (`string`, required)
- `User_name` (`string`, optional)
- `Password` (`string`, optional)
- `Query` (`string`, required)
- `Chunk_size` (`int`, optional)
- `Data` (`string`, required)
- `Consistency` (`string`, required)
- `Retention_policy` (`string`, optional)

### Outputs

- `Error Message` (`string`)
- `Response Code` (`int`)
- `Raw Output` (`string`)
- `Hash Output` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## InputManipulation

- **Display name**: Input Manipulations
- **Category**: Other Utilities
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in can be used to manipulate inputs using data operations based on the input type.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `input_type` | string |  |  |
| `operation` | string |  |  |
| `string_operation` | string |  |  |
| `array_operation` | string |  |  |
| `hash_operation` | string |  |  |
| `string_input1` | string |  | `String_input1` |
| `string_pattern` | string |  | `String_pattern` |
| `string_replace` | string |  | `String_replace` |
| `array_input1` | string |  | `Array_input1` |
| `array_input2` | string |  | `Array_input2` |
| `hash_input1` | string |  | `Hash_input1` |
| `hash_key` | string |  | `Hash_key` |

### Inputs

- `String_input1` (`string`, required)
- `String_pattern` (`string`, required)
- `String_replace` (`string`, required)
- `Array_input1` (`string`, required)
- `Array_input2` (`string`, required)
- `Hash_input1` (`string`, required)
- `Hash_key` (`string`, required)
- `array_input1` (`array`)
- `array_input2` (`array`)
- `hash_input1` (`hash`)
- `hash_key` (`string`)

### Outputs

- `output` (`string` or `array` or `flag` or `hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## IrtMxfAnalyser

- **Display name**: Irt mxf analyser
- **Category**: Quality Control
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This Action plug-ins enables the submission of a file verification request to a IRT MXF Analyser server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `job_name` | text |  |  |
| `file_path` | text |  |  |
| `profile_name` | text |  |  |
| `user_id` | text | `orchestrator` (code) |  |
| `priority` | text | `normal` (code) |  |
| `server_node` | string |  |  |
| `server_port` | string | `8080` (code) |  |
| `server_address` | string |  |  |

### Inputs

- `Service_node_or_address` (`string`)

### Outputs

- `Traffic light` (`string`)
- `Analysis report` (`string`)
- `Link to Report page` (`string`)
- `Errors warnings and infos` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## IsmM3u8Parser

- **Display name**: ISM and M3U8 File Parser
- **Category**: File Operations
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plugin provides ability to parse an ISM file and a M3U8 file

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `file_path` | string |  | `File_path` |
| `return_output_as_array` | boolean | `false` (code) | `Return_output_as` |

### Inputs

- `File_path` (`string`, required)
- `Return_output_as` (`array`, optional)

### Outputs

- `Hash_of_ISM_Filenames` (`hash`)
- `Hash_of_M3u8_Filenames` (`hash`)
- `Array_of_ISM_Filenames` (`array`)
- `Array_of_M3u8_Filenames` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## ItunesTransporter

- **Display name**: iTunes transporter
- **Category**: File Transfer
- **Version**: 0.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides the ability to deliver audio and video content, in a pre-generated iTunes Store package, to the iTunes Store.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `command_line_payload` | text | `"<%= proxy_tag(proxy_host, proxy_port, http_proxy_host, http_proxy_Port) %> \` (code) |  |
| `saved_inputs` | text |  | `Saved_inputs` |
| `execution_node` | string |  |  |
| `sender_node_address` | string | `localhost` (code) |  |
| `execution_login` | string |  |  |
| `execution_password` | string |  |  |
| `sender_node_port` | integer |  |  |
| `binary_path` | string | `/usr/local/itms/bin/iTMSTransporter` (code) |  |
| `sender_node_is_windows` | boolean |  |  |

### Inputs

- `Saved_inputs` (`string`, optional)

### Outputs

- `Uploaded_packages` (`hash`)
- `Failed_packages` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## JiraOperation

- **Display name**: JIRA Ticket Creation
- **Category**: Integration
- **Version**: 0.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to create JIRA tickets.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `title` | string |  | `Title` |
| `ticket_desc` | text |  | `Ticket_desc` |
| `ticket_type` | string |  | `Ticket Type` |
| `jira_url` | string |  | `Jira_url` |
| `priority` | string |  | `Priority` |
| `assignee` | string | `` (code) | `Assignee` |
| `proj_id` | string |  | `Project Key` |
| `username` | string |  | `Username` |
| `password` | string |  | `Password` |
| `component` | string | `` (code) | `Component` |
| `ssl_verification` | boolean | `true` | `Ssl_verification` |

### Inputs

- `Title` (`string`, required)
- `Ticket_desc` (`string`, required)
- `Ticket Type` (`string`, required)
- `Jira_url` (`string`, required)
- `Priority` (`string`, required)
- `Assignee` (`string`, optional)
- `Username` (`string`, required)
- `Password` (`string`, required)
- `Component` (`string`, optional)
- `Ssl_verification` (`flag`, required)
- `Project Key` (`string`, required)

### Outputs

- `Error_Message` (`string`)
- `Ticket_Id` (`string`)
- `Create_Ticket_Response` (`hash`)
- `Ticket_JSON_Info` (`string`)
- `Step_information` (`hash`)

## KafkaStream

- **Display name**: Kafka stream
- **Category**: Integration
- **Version**: 0.1.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin is used to send/receive messages to/from an Apache Kafka system.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `remote_address` | string |  | `Remote_address` |
| `remote_port` | string | `9092` (code) | `Remote_port` |
| `execution_node` | string |  | `Execution_node` |
| `topic` | string |  | `Topic` |
| `partition_id` | integer | `` (code) | `Partition_id` |
| `partition_key` | string | `` (code) | `Partition_key` |
| `message_key` | string | `` (code) | `Message_key` |
| `message_body` | text |  | `Message_body` |
| `group_id2` | string |  | `Group_id` |
| `pattern` | string | `` (code) | `Pattern` |
| `sync_producer` | boolean | `true` |  |
| `use_ssl` | boolean | `false` |  |
| `read_from_beginning` | boolean | `false` |  |
| `return_all` | boolean | `false` |  |
| `keep_ongoing` | boolean | `false` |  |
| `certificate_path` | string |  | `Certificate_path` |
| `operation_type` | string |  |  |
| `polling_frequency` | integer | `10` (code) |  |

### Inputs

- `Topic` (`string`, required)
- `Remote_address` (`string`, required)
- `Remote_port` (`string`, optional)
- `Execution_node` (`string`, required)
- `Message_body` (`string`, required)
- `Message_key` (`string`, optional)
- `Partition_key` (`string`, optional)
- `Partition_id` (`int`, optional)
- `Group_id` (`string`, required)
- `Pattern` (`string`, optional)
- `Certificate_path` (`string`, required)

### Outputs

- `Message_Body` (`array` or `string`)
- `Partition_ID` (`array` or `int`)
- `Message_Offset` (`array` or `int`)
- `Message_Key` (`array` or `string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## LoadBalancer

- **Display name**: Load balancer
- **Category**: Other Utilities
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in is a tool to manage resource distribution from a pool of resources using round-robin or random distribution algorithms.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `resource_list` | text |  | `Resource_list` |
| `unique_id` | string |  | `Resource_name` |
| `unicity_type` | string |  |  |
| `random_distribution` | boolean |  |  |

### Inputs

- `Resource_list` (`string` or `array`, required)
- `Resource_name` (`string`, optional)

### Outputs

- `Resource` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## LoadManager

- **Display name**: Load manager
- **Category**: Resources
- **Version**: 0.5.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin is a tool to balance requests for a pool of resources with specific capacities. It provides a way to pause workflows until enough resources become available, and routes requests to the least taxed resources.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `max_resources` | integer | `1` (code) |  |
| `resource_capacity` | integer | `1` (code) | `Resource_capacity` |
| `resource_list` | text |  | `Managed_resources` |
| `allocation_block` | integer | `1` (code) | `Allocation_block` |
| `unique_id` | string |  | `Resource_pool_name` |
| `unicity_type` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `keep_ongoing` | boolean | `false` |  |
| `resource_wait_timeout` | integer |  |  |
| `resource_hold_timeout` | integer |  |  |
| `queue_id` | string |  | `Queue_id` |
| `use_weight_for_allocation` | boolean |  |  |
| `on_wait_timeout` | string | `ACTION_FAIL` (code) |  |
| `manager_action` | string | `ACTION_RESERVE` (code) |  |
| `allocation_label` | string |  | `Allocation_label` |
| `is_adhoc` | boolean | `true` |  |
| `pool_name` | text |  | `Pool_name` |
| `allocation_policy` | string |  | `Allocation_policy` |

### Inputs

- `Allocation_policy` (`string`, required)
- `Managed_resources` (`string` or `<resource_capacity>`, required)
- `Resource_capacity` (`int`, optional)
- `Resource_pool_name` (`string`, required)
- `Allocation_label` (`string`, optional)
- `Queue_id` (`string`, optional)
- `Allocation_block` (`int`, optional)
- `Pool_name` (`string`, required)
- `Allocation_token_to_release` (`int`)
- `Expected_queued_item` (`string`)
- `Queue` (`string`)

### Outputs

- `Resource_reserved` (`string`)
- `Queued_item` (`string`)
- `Queued_item_description` (`string`)
- `Queued_item_tags` (`string`)
- `Capacity_released` (`int`)
- `Allocation_token` (`int`)
- `Capacity_reserved` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- A name in angle brackets (`<attribute>`) is the value of that template attribute.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## LocalExecution

- **Display name**: Local execution
- **Category**: Integration
- **Version**: 0.4.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to invoke a third-party application or a script running locally on the workflow server. The integration mechanism conforms to the CGI-BIN protocol used by web and application servers (i.e. input parameters are provided as environment variable, output is provided on the stdio).

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `command` | string |  |  |
| `parallel_execution` | boolean |  |  |
| `stored_script` | text |  |  |
| `formatted_outputs` | text |  |  |
| `multi_line` | boolean |  |  |
| `mandatory_inputs` | text |  |  |
| `optional_inputs` | text |  |  |

### Inputs

- None found in source.

### Outputs

- `Multi` (`array`)
- `stdio` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## LocalFileOperation

- **Display name**: Local file operation
- **Category**: File Operations
- **Version**: 1.2.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug‑in executes local file operations on Orchestrator‑mounted file systems. It supports actions such as copy, move, delete, makedir, sym‑link, touch, listing, and archive handling, with options for validation, overwriting, timestamp preservation, and permissions control.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `sources` | string |  | `Sources` |
| `target` | string |  | `target` |
| `overwrite_flag` | boolean |  |  |
| `base` | string |  | `base` |
| `preserve_timestamp` | boolean |  |  |
| `fail_on_incomplete` | boolean | `1` |  |
| `block_size` | integer |  |  |
| `chmod` | string |  | `Chmod` |
| `uid` | string |  | `Uid` |
| `guid` | string |  | `Guid` |
| `recursive` | boolean | `false` |  |
| `expose_explicit_failed_list` | boolean | `false` | `Expose_explicit_failed_list` |
| `is_hard_link` | boolean | `false` |  |
| `fail_on_empty` | boolean | `false` |  |
| `validate_source` | boolean |  |  |
| `source_no_glob` | boolean |  |  |

### Inputs

- `Chmod` (`string`, optional)
- `Uid` (`string`, optional)
- `Guid` (`string`, optional)
- `Expose_explicit_failed_list` (`flag`, optional)
- `target` (`string`, required)
- `base` (`string`, optional)
- `Sources` (`string`, required)
- `preserve_timestamp` (`flag`)
- `overwrite_flag` (`flag`)
- `source` (`array` or `string`)

### Outputs

- `File_list` (`array`)
- `Failed_list` (`array`)
- `All_Failed_Files` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## LocalFilePermission

- **Display name**: Local file permission
- **Category**: File Operations
- **Version**: 0.1.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to do the chmod and chown file operations after a file has been downloaded.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `source_files` | string |  | `Source_files` |
| `chmod` | string |  | `Permissions` |
| `uid` | string |  | `Uid` |
| `gid` | string |  | `Gid` |
| `recursive` | boolean | `false` (code) | `Recursive` |

### Inputs

- `Source_files` (`string` or `array`, required)
- `Permissions` (`string`, optional)
- `Uid` (`string`, optional)
- `Gid` (`string`, optional)
- `Recursive` (`flag`, optional)

### Outputs

- `CHOWN_File_list` (`array`)
- `CHOWN_Failed_list` (`array`)
- `CHMOD_File_list` (`array`)
- `CHMOD_Failed_list` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## LocalFileWatcher

- **Display name**: Local file watcher
- **Category**: Triggers
- **Version**: 1.9.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in watches a local directory for files matching defined patterns and enables the creation of triggers upon detection.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `directory` | string |  | `directory` |
| `use_regex_matching` | boolean |  |  |
| `tempo` | integer | `(DEFAULT_POLLING_FREQUENCY * 1000)` (code) |  |
| `partial_file` | boolean |  |  |
| `return_all` | boolean |  |  |
| `run_synchronous` | boolean |  |  |
| `trigger_type` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `comments` | text |  |  |
| `ignore_zero_bytes` | boolean | `false` |  |
| `exclusions` | string |  | `Exclusions` |
| `fullpath_exclusions` | string |  | `Fullpath_exclusions` |
| `ignore_readlocked` | boolean | `false` |  |
| `multi_folders` | boolean | `false` |  |
| `cool_off` | integer |  |  |
| `aggressive_pruning` | boolean |  |  |
| `pruning_beacon_file_path` | string |  |  |
| `keep_timestamps` | boolean |  |  |
| `allow_multiple` | boolean |  |  |
| `base_dir` | string |  |  |
| `file_name` | string |  | `File_name` |
| `read_file` | boolean |  |  |
| `remove_file` | boolean |  |  |
| `archive_directory` | string |  |  |
| `archive_with_timestamp` | boolean |  |  |

### Inputs

- `File_name` (`string`, required)
- `directory` (`string` or `array`, required)
- `Exclusions` (`string`, optional)
- `Fullpath_exclusions` (`string`, optional)
- `removeFile` (`flag`)
- `archiveWithTimestamp` (`flag`)
- `allowMultiple` (`flag`)
- `readFile` (`flag`)
- `tempo` (`int`)
- `maxEntries` (`int`)
- `timeout` (`int`)
- `includeFolders` (`flag`)
- `directoryBase` (`string`)
- `archiveDirectory` (`string`)
- `persistenceScope` (`string`)
- `fileName` (`string`)

### Outputs

- `FileName` (`array` or `string`)
- `FileContent` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## LocalFolderWatcher

- **Display name**: Local folder watcher
- **Category**: Triggers
- **Version**: 1.6.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to wait for the arrival of folder matching a certain pattern and optionally wait for the stability of all files in that folder.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `watch_directory` | string |  | `watch_directory` |
| `folder_pattern` | string |  | `Folder_pattern` |
| `use_regex_matching` | boolean |  |  |
| `trigger_type` | string |  |  |
| `polling_frequency` | integer | `10` (code) | `Polling_frequency` |
| `keep_ongoing` | boolean |  |  |
| `trigger_on_partial` | boolean |  |  |
| `return_all` | boolean |  |  |
| `return_content_list` | boolean |  |  |
| `partial_regex` | string |  |  |
| `reject_regex` | string |  | `Reject_regex` |
| `reject_full_directory_regex` | boolean |  |  |
| `multi_folders` | boolean | `false` |  |
| `reject_empty_folders` | boolean | `false` |  |
| `aggressive_pruning` | boolean | `false` |  |
| `pruning_beacon_file_path` | string |  |  |

### Inputs

- `watch_directory` (`string` or `array`, required)
- `Folder_pattern` (`string`, optional)
- `Reject_regex` (`string`, optional)
- `Polling_frequency` (`int`, optional)
- `persistenceScope` (`string`)
- `Folder_path` (`string`)
- `Content` (`array` or `hash`)
- `Folder_list` (`array`)

### Outputs

- `Folder_path` (`string`)
- `Content` (`array` or `hash`)
- `Folder_list` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## MacCaptionOperation

- **Display name**: MacCaption Operation
- **Category**: File Transformations
- **Version**: 0.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to perform captioning operation using the Telestream MacCaption application.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execution_node` | string |  | `Execution_node` |
| `execution_login` | string |  |  |
| `execution_password` | string |  |  |
| `binary_path` | string | `/Applications/MacCaption.app/Contents/MacOS/MacCaption` (code) |  |
| `operation` | string |  |  |
| `input_media_file_path` | string |  | `Input_media_file_path` |
| `input_caption_source_file_path` | string |  | `Input_caption_source_file_path` |
| `output_media_file_path` | string |  |  |
| `output_caption_file_path` | string |  | `Output_caption_file_path` |
| `input_caption_format` | string |  | `Input_caption_format` |
| `output_caption_format` | string |  | `Output_caption_format` |
| `job_options` | text | `` (code) | `Job_Options` |
| `input_options` | text | `` (code) | `Input_options` |
| `output_options` | text | `` (code) | `Output_options` |
| `options` | text | `` (code) |  |
| `raw_command_line` | text | `` (code) | `Raw_command_line` |
| `commands` | text | `` (code) | `Commands` |
| `trim_inpoint` | string | `` (code) | `Trim_inpoint` |
| `trim_outpoint` | string | `` (code) | `Trim_outpoint` |

### Inputs

- `Raw_command_line` (`string`, optional)
- `Execution_node` (`string`, required)
- `Input_caption_source_file_path` (`string`, required)
- `Job_Options` (`string`, optional)
- `Input_options` (`string`, optional)
- `Input_caption_format` (`string`, required)
- `Output_caption_format` (`string`, required)
- `Output_caption_file_path` (`string`, required)
- `Commands` (`string`, optional)
- `Trim_inpoint` (`string`, optional)
- `Trim_outpoint` (`string`, optional)
- `Output_options` (`string`, optional)
- `Input_media_file_path` (`string`, required)

### Outputs

- `Raw_report` (`string`)
- `Captions_read` (`int`)
- `Output_caption_file_path` (`string`)
- `Step_information` (`hash`)

## MarquisMewsOperation

- **Display name**: Marquis Mews Operation
- **Category**: Transcoding
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plug-in provides the ability to use the API's listed under the Medway Web Service solution of Marquis.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `url` | text |  | `Url` |
| `payload` | text |  | `Payload` |
| `operation` | text |  | `Operation` |
| `saved_inputs` | text |  |  |

### Inputs

- `Url` (`string`, required)
- `Payload` (`string`, required)
- `Operation` (`string`, required)

### Outputs

- `Response Received` (`hash`)
- `Error Message` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## MassParameterSetter

- **Display name**: Stored parameter set
- **Category**: Other Utilities
- **Version**: 0.6.6 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to set the values of multiple parameters within a workflow step. It can be used to store default values or apply a predefined set of values for reuse across workflows. This helps reduce duplication and ensures consistency when configuring actions.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `parameters` | text |  | `Parameters` |
| `use_external_storage` | boolean |  |  |
| `config_name` | string |  | `Config_name` |

### Inputs

- `Config_name` (`string`, required)
- `Parameters` (`string`, required)

### Outputs

- `Stored_parameters` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## McAfeeVirusCheck

- **Display name**: McAfee virus check
- **Category**: Virus Scan
- **Version**: 0.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to check a file, folder or set of files for viruses using the McAfee anti-virus application.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `av_scanner` | string |  |  |
| `execution_node` | string |  |  |
| `execution_login` | string |  |  |
| `execution_password` | string |  |  |
| `binary_path` | string |  |  |
| `input_file_path` | string |  | `Input_file_path` |
| `include_files_pattern` | string |  |  |
| `exclude_files_pattern` | string |  |  |
| `quarantine_folder` | string |  |  |
| `clean_folder` | string |  |  |
| `file_base` | string |  |  |
| `fail_on_infection` | boolean |  |  |
| `return_full_report` | boolean |  |  |
| `options` | string |  | `Options` |
| `single_file_mode` | boolean |  |  |
| `truncate_infected_file` | boolean |  |  |
| `max_scan_size` | integer |  |  |
| `above_max_action` | string |  |  |
| `node_type` | boolean |  |  |
| `delete_infected_file` | boolean |  |  |

### Inputs

- `Input_file_path` (`string`, required)
- `Options` (`string`, optional)
- `McAfeeAV_node` (`string`)
- `Execution_login` (`string`)
- `Execution_password` (`string`)
- `Binary_path` (`string`)

### Outputs

- `Clean_files` (`array`)
- `Infected_files` (`array`)
- `Scan_Summary` (`string`)
- `Scan_report` (`string`)
- `Output_file_path` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## Md5Checksum

- **Display name**: MD5 checksum
- **Category**: File Operations
- **Version**: 0.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in calculates MD5 checksums for specified files and optionally verifies them against previously calculated values. It supports memory-efficient processing with configurable block sizes and dynamic file path inputs for flexible file integrity verification workflows.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `file_path` | string |  | `File_path` |
| `block_size` | integer | `131072` (code) |  |

### Inputs

- `File_path` (`string`, required)
- `Check_against` (`string`)

### Outputs

- `MD5_checksum` (`string`)
- `Checked_filepath` (`string`)
- `Check_against` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## MediaInfo

- **Display name**: Media info
- **Category**: File Operations
- **Version**: 0.7.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin extracts comprehensive technical and tag metadata from video and audio files using the MediaInfo application.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `media_file_path` | string |  |  |
| `options` | string |  |  |
| `detailed_mode` | boolean |  |  |
| `execution_node` | string |  | `Execution_node` |
| `execution_login` | string |  | `Execution_login` |
| `execution_password` | string |  | `Execution_password` |
| `binary_path` | string | `mediainfo` (code) | `Binary_path` |
| `format_result` | text |  |  |
| `additional_outputs` | text |  |  |
| `additional_sections` | text |  |  |
| `local_execution` | boolean |  |  |
| `skip_cover_data_output` | boolean | `false` (code) | `Skip_cover_data_output` |
| `xml_output` | boolean | `false` (code) | `Xml_output` |

### Inputs

- `Execution_node` (`string`, required)
- `Binary_path` (`string`, optional)
- `Execution_login` (`string`, optional)
- `Execution_password` (`string`, optional)
- `Xml_output` (`flag`, optional)
- `Skip_cover_data_output` (`flag`, optional)
- `Media_file_path` (`string`)
- `options` (`string`)

### Outputs

- `General` (`hash`)
- `Video` (`hash`)
- `Audio` (`hash`)
- `Image` (`hash`)
- `XML output` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## MediaMateOperation

- **Display name**: Media Mate Operation
- **Category**: Integration
- **Version**: 0.3.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin can be used to interact with the MediaMate subtitling service.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `url` | string |  | `Url` |
| `server` | string |  | `Server` |
| `port` | integer | `8080` (code) | `Port` |
| `operation` | string |  | `Operation` |
| `model_path` | string |  | `Model_path` |
| `polling_frequency` | integer | `5` (code) | `Polling_frequency` |
| `xmlcfg` | mediumtext | `` (code) | `Xmlcfg` |

### Inputs

- `Url` (`string`, required)
- `Server` (`string`, required)
- `Port` (`int`, optional)
- `Operation` (`string`, required)
- `Model_path` (`string`, required)
- `Xmlcfg` (`string`, optional)
- `Polling_frequency` (`int`, optional)

### Outputs

- `Short Name` (`string`)
- `Job State` (`string`)
- `Job State Description` (`string`)
- `MediaMate Error` (`string`)
- `Full Response` (`hash`)
- `Error Message` (`string`)
- `FLX Player State Value` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## MediabinAssetManagement

- **Display name**: Mediabin asset management
- **Category**: File Operations
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plugin provide the ability to perform some asset management on a Mediabin server. Supported operations include asset listing and retrieval (with download).

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `mediabin_node` | string |  | `Mediabin_node` |
| `mediabin_address` | string |  | `Mediabin node or address` |
| `mediabin_wsdl_url` | string |  | `Mediabin_wsdl_url` |
| `mediabin_user` | string |  | `Mediabin_user` |
| `mediabin_password` | string |  | `Mediabin_password` |
| `operation` | string |  |  |
| `mediabin_path` | string |  | `Mediabin_path` |
| `local_path` | string |  | `Local_path` |
| `use_ssl` | boolean |  |  |

### Inputs

- `Mediabin_wsdl_url` (`string`, required)
- `Mediabin_node` (`string`, required)
- `Mediabin node or address` (`string`, required)
- `Mediabin_path` (`string`, required)
- `Local_path` (`string`, required)
- `Mediabin_user` (`string`, required)
- `Mediabin_password` (`string`, required)
- `Assets` (`array`)

### Outputs

- `Assets` (`array`)
- `Local_path` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## MergePoint

- **Display name**: Merge point
- **Category**: System
- **Version**: 0.5.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin can be used to reconcile inputs coming from different branches of logical statements. It provides the ability to define pairs of inputs that get merged. Such steps can be used without inputs to clarify branching in complex workflows.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `merged_inputs` | text |  |  |
| `multi_inputs` | text |  |  |
| `consider_blank_nil` | boolean | `true` |  |
| `mandatory_inputs` | text |  |  |
| `optional_inputs` | text |  |  |

### Inputs

- None found in source.

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## MimirOperation

- **Display name**: Mimir Operation
- **Category**: Integration
- **Version**: 1.0.0 (requires Orchestrator 4.1.6 or later)
- **Description**: Search, create, ingest, and manage assets in Mimir Cloud MAM. Supports metadata updates, transcript management, folder operations, archiving, and direct file upload with automatic multipart handling for large files.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  | `Name` |
| `comments` | text |  | `Comments` |
| `base_url` | string |  | `Base_url` |
| `api_key` | text |  | `Api_key` |
| `operation` | string |  | `Operation` |
| `item_id` | string |  | `Item_id` |
| `fields` | string |  | `Fields` |
| `search_string` | string |  | `Search` |
| `search_mode` | string |  | `Search_mode` |
| `search_folder_id` | string |  | `Search_folder_id` |
| `include_subfolders` | boolean |  | `Include_subfolders` |
| `include_folders` | boolean |  | `Include_folders` |
| `page_size` | integer |  | `Page_size` |
| `metadata_delta_json` | text |  | `Metadata_delta_json` |
| `required_metadata_version` | string |  | `Required_metadata_version` |
| `folder_path` | string |  | `Folder_path` |
| `root_folder_id` | string |  | `Root_folder_id` |
| `target_folder_id` | string |  | `Target_folder_id` |
| `config_id` | string |  | `Config_id` |
| `src_key` | string |  | `Src_key` |
| `placeholder_id` | string |  | `Placeholder_id` |
| `timed_metadata_json` | text |  | `Timed_metadata_json` |
| `transcript_json` | text |  | `Transcript_json` |
| `archive_type` | string |  | `Archive_type` |
| `archive_path` | string |  | `Archive_path` |
| `archive_media_only` | boolean |  | `Archive_media_only` |
| `file_path` | string |  | `File_path` |
| `file_name` | string |  | `File_name` |
| `content_type` | string |  | `Content_type` |
| `external_id` | string |  | `External_id` |
| `upload_item_type` | string |  | `Upload_item_type` |
| `upload_folder_parents` | text |  | `Upload_folder_parents` |
| `upload_metadata_json` | text |  | `Upload_metadata_json` |
| `upload_transcription_enabled` | boolean |  | `Upload_transcription_enabled` |
| `upload_person_detection_enabled` | boolean |  | `Upload_person_detection_enabled` |
| `upload_label_detection_enabled` | boolean |  | `Upload_label_detection_enabled` |
| `upload_celebrity_detection_enabled` | boolean |  | `Upload_celebrity_detection_enabled` |
| `chunk_size_bytes` | integer |  | `Chunk_size_bytes` |

### Inputs

- `Name` (`string`, required)
- `Comments` (`string`, required)
- `Base_url` (`string`, required)
- `Api_key` (`string`, required)
- `Operation` (`string`, required)
- `Item_id` (`string`, required)
- `Fields` (`string`, required)
- `Search` (`string`, required)
- `Search_mode` (`string`, required)
- `Search_folder_id` (`string`, required)
- `Include_subfolders` (`flag`, required)
- `Include_folders` (`flag`, required)
- `Page_size` (`int`, required)
- `Metadata_delta_json` (`string`, required)
- `Required_metadata_version` (`string`, required)
- `Folder_path` (`string`, required)
- `Root_folder_id` (`string`, required)
- `Target_folder_id` (`string`, required)
- `Config_id` (`string`, required)
- `Src_key` (`string`, required)
- `Placeholder_id` (`string`, required)
- `Timed_metadata_json` (`string`, required)
- `Transcript_json` (`string`, required)
- `Archive_type` (`string`, required)
- `Archive_path` (`string`, required)
- `Archive_media_only` (`flag`, required)
- `File_path` (`string`, required)
- `File_name` (`string`, required)
- `Content_type` (`string`, required)
- `External_id` (`string`, required)
- `Upload_item_type` (`string`, required)
- `Upload_folder_parents` (`string`, required)
- `Upload_metadata_json` (`string`, required)
- `Upload_transcription_enabled` (`flag`, required)
- `Upload_person_detection_enabled` (`flag`, required)
- `Upload_label_detection_enabled` (`flag`, required)
- `Upload_celebrity_detection_enabled` (`flag`, required)
- `Chunk_size_bytes` (`int`, required)

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- No `inputs_spec` in plugin class: every template field left blank becomes an input (default behavior).
- No `outputs_spec` in plugin class.

## MinnetonkaAudiotoolserver

- **Display name**: Minnetonka AudioTools Server
- **Category**: Transcoding
- **Version**: 0.3.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plug-in provides the ability to process, convert, encode, and decode audio files with the Minnetonka AudioTools Server. It implements the AudioTools SOAP based WEB service API.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `remote_node` | string |  |  |
| `server_address` | string |  |  |
| `server_port` | integer | `9090` (code) |  |
| `polling_frequency` | integer | `10` (code) |  |
| `workflowxml` | string |  | `Workflowxml` |
| `priority` | string |  | `priority` |
| `init_from_type` | string |  |  |
| `wsdl_type` | string | `ATSWFManagementService.wsdl` (code) |  |
| `disable_escape_html` | boolean |  |  |

### Inputs

- `Workflowxml` (`string`, required)
- `priority` (`string`, required)
- `remote node or server address` (`string`)

### Outputs

- `XML_result` (`string`)
- `ATS_status_message` (`string`)
- `ATS_Log_Messages` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## MogMxfSpeedrail

- **Display name**: MOG MXF Speedrail
- **Category**: Transcoding
- **Version**: 0.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: his plug-in provides the ability to run a MOG workflow. It implements MOG mxfSPEEDRAIL v2.22 SOAP API.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `remote_node` | string |  |  |
| `server_address` | string |  |  |
| `server_port` | integer | `8731` (code) |  |
| `polling_frequency` | integer | `10` (code) |  |
| `xml_payload` | text |  | `xml payload` |
| `flow_name` | string |  | `flow name` |
| `username` | string |  | `user name` |
| `password` | string |  | `password` |
| `job_name` | string | `Orchestrator job` (code) | `Job Name` |

### Inputs

- `xml payload` (`string`, required)
- `flow name` (`string`, required)
- `user name` (`string`, required)
- `password` (`string`, required)
- `Job Name` (`string`, optional)
- `remote node or server address` (`string`)

### Outputs

- `XML_result` (`string`)
- `MOG_error_message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## MongodbOperation

- **Display name**: Mongodb operation
- **Category**: Integration
- **Version**: 1.3.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin enables interaction with MongoDB databases, supporting document operations (insert, find, update, remove), advanced queries, aggregation pipelines, map-reduce processing, and database administration commands for comprehensive data management and analysis.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `additional_arguments` | text |  |  |
| `additional_options` | text |  |  |
| `allow_all_to_be_removed` | boolean | `false` (code) |  |
| `client_options` | text | `{}` (code) | `Client_options` |
| `collection_name` | string |  |  |
| `collection_options` | text | `{}` (code) |  |
| `condition` | text |  |  |
| `connection_uri` | text | `mongodb://localhost:27017` (code) | `Connection_uri` |
| `database_name` | string | `test` (code) | `Database_name` |
| `database_options` | text | `{}` (code) | `Database_options` |
| `document` | text |  |  |
| `finalize_function` | text |  |  |
| `initial` | text |  |  |
| `key` | text |  | `Key` |
| `map_function` | text |  | `Map_function` |
| `operation` | string |  | `Operation` |
| `options` | text | `{}` (code) |  |
| `pipeline` | text |  | `Pipeline` |
| `reduce_function` | text |  | `Reduce_function` |
| `selector` | text | `{}` (code) |  |
| `specification` | text |  |  |
| `logging_enabled` | boolean |  |  |

### Inputs

- `Connection_uri` (`string`, optional)
- `Database_name` (`string`, optional)
- `Operation` (`string`, required)
- `Client_options` (`string` or `hash`, optional)
- `Database_options` (`string` or `hash`, optional)
- `Pipeline` (`string` or `array`, required)
- `Key` (`string`, required)
- `Map_function` (`string`, required)
- `Reduce_function` (`string`, required)
- `Logging_enabled` (`flag`)
- `Allow_all_to_be_removed` (`flag`)

### Outputs

- `Response` (`hash`)
- `Results` (`array`)
- `Count` (`int`)
- `Document` (`hash`)
- `Document_id` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## MxFixer

- **Display name**: Mx fixer
- **Category**: Quality Control
- **Version**: 0.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: Analyse an MXF file for AS11 compatibility using Metaglue MX Fixer.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `file_path` | string |  | `File_path` |
| `report_path` | string | `` (code) | `Report_path` |
| `max_level_for_success` | integer | `6` (code) | `Max_level_for_success` |
| `execution_node` | string |  | `Execution_node` |
| `execution_login` | string |  |  |
| `execution_password` | string |  |  |
| `binary_path` | string | `C:\\Program Files (x86)\\Metaglue\\MXFixer\\Fixerscript.exe` (code) |  |
| `script_path` | string | `C:\\Program Files (x86)\\Metaglue\\MXFixer\\FixerScript\\FixertestXML.cfx` (code) | `Script_path` |
| `options` | string |  |  |

### Inputs

- `File_path` (`string`, required)
- `Max_level_for_success` (`int`, optional)
- `Report_path` (`string`, optional)
- `Script_path` (`string`, optional)
- `Execution_node` (`string`, required)

### Outputs

- `Verification result` (`flag`)
- `Report file absolute path` (`string`)
- `All verification messages (Level->[Text])` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## MxfLegalizer

- **Display name**: MXF Legalizer
- **Category**: File Transformations
- **Version**: 0.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plug-in provides the ability to make compliant a MXF file. It implements the MXF Legalizer v2.5.2 SOAP API.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `remote_node` | string |  |  |
| `server_address` | string |  |  |
| `server_port` | integer | `8080` (code) |  |
| `polling_frequency` | integer | `10` (code) |  |
| `source` | string |  | `source` |
| `priority` | string |  | `priority` |
| `resource_id` | string |  | `resource_id` |
| `expose_result_as_hash` | boolean | `false` |  |

### Inputs

- `source` (`string`, required)
- `priority` (`string`, required)
- `resource_id` (`string`, required)
- `XML_result` (`hash` or `string`)
- `remote node or server address` (`string`)

### Outputs

- `XML_result` (`hash` or `string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## OpswatMetadefender

- **Display name**: Opswat metadefender
- **Category**: Virus Scan
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: Integration with Opswat Metadefender

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `opswat_address` | string |  |  |
| `port` | integer | `8008` (code) |  |
| `apikey` | string | `` (code) |  |
| `username` | string | `` (code) |  |
| `password` | string | `` (code) |  |
| `files` | string |  |  |
| `separator` | string | `,` (code) |  |
| `user_agent` | string | `Aspera Orchestrator` (code) |  |
| `rule` | string |  |  |
| `archivepwd` | string | `` (code) |  |
| `failinfected` | boolean | `false` (code) |  |
| `polling_frequency` | integer | `5` (code) |  |

### Inputs

- `user` (`<username>`)
- `password` (`<password>`)

### Outputs

- `Scan result` (`hash`)
- `Clean Files` (`array`)
- `Infected Files` (`array`)
- `Sanitised Data ID` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- A name in angle brackets (`<attribute>`) is the value of that template attribute.

## OrchestratorAlertEntry

- **Display name**: Orchestrator Alert Configuration
- **Category**: System
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin is used to enter custom alerts into orchestrator

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `category_type` | integer |  | `Category_type` |
| `header` | string | `` (code) | `Header` |
| `alert_message` | text |  | `Alert_message` |

### Inputs

- `Category_type` (`int`, required)
- `Alert_message` (`string`, required)
- `Header` (`string`, optional)

### Outputs

- `Alert Entered` (`flag`)
- `Alert Message` (`string`)
- `Step_information` (`hash`)

## OrionOttMonitor

- **Display name**: Orion OTT Monitor
- **Category**: Quality Control
- **Version**: 0.3.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This is Action plug-ins provides the ability to submit file to Orion OTT Monitor

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execution_node` | string |  |  |
| `server_address` | string |  | `Server_address` |
| `orion_port` | integer | `2029` (code) | `Orion_port` |
| `content_status_polling_frequency` | integer | `15` (code) |  |
| `content_monitoring_polling_frequency` | integer | `300` (code) |  |
| `encryption_type` | string |  | `Encryption_type` |
| `orion_username` | string | `admin` (code) | `Orion_username` |
| `orion_password` | string | `admin` (code) | `Orion_password` |
| `orion_cookie` | string |  |  |
| `content_name` | string |  | `Content_name` |
| `pdf_file_path` | string |  | `Pdf_file_path` |
| `content_url` | text |  | `Content_url` |
| `register_keys` | text |  | `Register_keys` |
| `decode_media_segments` | boolean | `true` |  |
| `enabled_quality` | boolean | `true` |  |
| `enabled_loudness` | boolean | `true` |  |
| `monitoring_profile` | string |  | `Monitoring_profile` |
| `monitoring_template` | string |  | `Monitoring_template` |

### Inputs

- `Orion_port` (`int`, optional)
- `Orion_username` (`string`, optional)
- `Orion_password` (`string`, optional)
- `Content_name` (`string`, required)
- `Content_url` (`string`, required)
- `Register_keys` (`string`, optional)
- `Pdf_file_path` (`string`, required)
- `Encryption_type` (`string`, required)
- `Monitoring_profile` (`string`, optional)
- `Monitoring_template` (`string`, optional)
- `Server_address` (`string`, required)
- `Minor_Errors_Count` (`int`)
- `Major_Errors_Count` (`int`)
- `Critical_Errors_Count` (`int`)
- `Pdf_Report_Path` (`string`)
- `Content_Id` (`int`)
- `HTTP_Response_Code` (`int`)
- `Raw_Response_Hash` (`hash`)
- `Orion_Code_Received` (`int`)
- `Message_Received` (`string`)
- `Content_Register_Error_Message` (`string`)
- `Key_Register_Error_Message` (`string`)
- `Asset_Summary` (`hash`)
- `Play_Url` (`string`)

### Outputs

- `Minor_Errors_Count` (`int`)
- `Major_Errors_Count` (`int`)
- `Critical_Errors_Count` (`int`)
- `Pdf_Report_Path` (`string`)
- `Content_Id` (`int`)
- `HTTP_Response_Code` (`int`)
- `Raw_Response_Hash` (`hash`)
- `Orion_Code_Received` (`int`)
- `Message_Received` (`string`)
- `Content_Register_Error_Message` (`string`)
- `Key_Register_Error_Message` (`string`)
- `Asset_Summary` (`hash`)
- `Play_Url` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## PasswordGenerator

- **Display name**: Password generator
- **Category**: Other Utilities
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides the ability to generate random strings that can be used as passwords. The length and constraint of the generated random strings can be configured. Generated passwords can optionally be encrypted for secure storage.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `character_set` | string | `abcdefghijklmnopqrstuvwxywABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_*!+=()` (code) | `Character_set` |
| `constraints` | text | `["ABCDEFGHIJKLMNOPQRSTUVWXYZ", "0123456789", "-_*!+=()"]` (code) | `Constraints` |
| `length` | integer | `8` (code) | `Length` |
| `keep_encrypted` | boolean |  |  |
| `no_constraints` | boolean |  |  |

### Inputs

- `Character_set` (`string`, optional)
- `Constraints` (`string`, optional)
- `Length` (`int`, optional)

### Outputs

- `Generated password` (`string`)
- `Encrypted generated password` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## PulsarContentVerification

- **Display name**: Pulsar content verification
- **Category**: Quality Control
- **Version**: 0.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This Action plug-in provides the ability to submit a content verification task to a Pulsar Server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server_node` | string |  |  |
| `server_address` | string |  |  |
| `server_api_port` | integer | `8093` (code) |  |
| `template_name` | string |  | `Template_name` |
| `source_file` | string |  | `Source_file` |
| `polling_frequency` | integer | `5` (code) |  |

### Inputs

- `Template_name` (`string`, required)
- `Source_file` (`string`, required)
- `Pulsar_server_address` (`string`)

### Outputs

- `Input_Media_Params` (`string`)
- `Job_ID` (`string`)
- `Content_Verification_Result` (`string`)
- `Content_Verification_Stats` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## QscanFileVerification

- **Display name**: QScan file verification
- **Category**: Quality Control
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to submit and monitor a file verification job to a QScan server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `address` | string |  |  |
| `port` | string | `8080` (code) |  |
| `username` | string |  |  |
| `password` | string |  |  |
| `template_id` | string |  |  |
| `repository_id` | string |  |  |
| `file_path` | string |  |  |
| `job_name` | string |  |  |
| `save_pdf_report` | boolean |  |  |
| `pdf_report_file_path` | string |  |  |
| `delete_completed_job` | boolean |  |  |
| `polling_frequency` | integer | `10` (code) |  |

### Inputs

- None found in source.

### Outputs

- `job_name` (`string`)
- `events` (`array`)
- `pdf_file_size` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## QuasarVeneraQcOperation

- **Display name**: Quasar Venera QC
- **Category**: Quality Control
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This Action plug-ins enables the submission of a file verification request to an Quasar Venera QC server

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `account_id` | string |  | `Account_id` |
| `api_key` | string |  | `Api_key` |
| `request_name` | string |  |  |
| `end_point_url` | text |  | `End_point_url` |
| `file_path` | text |  | `File_path` |
| `template_name` | string |  | `Template_name` |
| `template_type` | integer |  | `Template_type` |
| `job_type` | integer |  | `Job_type` |
| `user_note` | string | `` (code) | `User_note` |
| `access_key_id` | string |  | `Access_key_id` |
| `access_key_secret` | string |  | `Access_key_secret` |
| `polling_frequency` | integer | `10` (code) |  |

### Inputs

- `Account_id` (`string`, required)
- `Api_key` (`string`, required)
- `End_point_url` (`string`, required)
- `File_path` (`string`, required)
- `Template_name` (`string`, required)
- `Template_type` (`int`, required)
- `Job_type` (`int`, required)
- `Access_key_id` (`string`, required)
- `Access_key_secret` (`string`, required)
- `User_note` (`string`, optional)
- `Error_Message` (`string`)
- `Create_Job_Raw_Response` (`hash`)
- `Job_Status_Raw_Response` (`hash`)
- `Message_Received` (`string`)
- `Error_Count` (`int`)
- `Warning_Count` (`int`)

### Outputs

- `Error_Message` (`string`)
- `Create_Job_Raw_Response` (`hash`)
- `Job_Status_Raw_Response` (`hash`)
- `Message_Received` (`string`)
- `Error_Count` (`int`)
- `Warning_Count` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## QueueStager

- **Display name**: Queue stager
- **Category**: Other Utilities
- **Version**: 0.9.5 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin is a tool to stage items into a managed queue. It provides a way to pause a workflow until all items queued ahead have been released from the queue. While staged in the queue, the items can be re-ordered by a user with appropriate privileges.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `queue_name` | string |  | `Queue_ID` |
| `queued_item` | string |  |  |
| `item_description` | string |  |  |
| `priority` | integer | `ManagedQueue::DEFAULT_PRIORITY` (code) | `Priority` |
| `users` | string |  |  |
| `groups` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `adhoc_queue` | boolean |  |  |
| `operation` | string |  |  |
| `keep_ongoing` | boolean |  |  |
| `weight` | integer | `ManagedQueue::DEFAULT_WEIGHT` (code) |  |
| `lifetime` | string |  |  |
| `max_item_count` | integer |  |  |
| `omit_description` | boolean |  |  |
| `tags` | text |  | `Tags` |

### Inputs

- `Queue_ID` (`string`, required)
- `Priority` (`int` or `array`, optional)
- `Tags` (`string` or `<tags>`, optional)
- `Queued_item` (`string` or `array`)
- `Queued_item_description` (`array` or `string`)
- `Weight` (`array` or `int`)
- `Max_item_count` (`int`)

### Outputs

- `Queued_items` (`array` or `int`)
- `Total_weight` (`int`)
- `Queue_status` (`string`)
- `Queued_item` (`string` or `array`)
- `Item_id` (`int`)
- `Tags` (`string` or `<tags>`)
- `Queued_item_description` (`string` or `array`)
- `Weight` (`int` or `array`)
- `Rank` (`int`)
- `Time in queue` (`int`)
- `Items added` (`int`)
- `Queue_ID` (`string`)
- `Priority` (`array`)
- `Max_item_count` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- A name in angle brackets (`<attribute>`) is the value of that template attribute.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## RegexMatcher

- **Display name**: Regex matcher
- **Category**: Other Utilities
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to parse a regex expression and extract parts of it

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `expression` | string |  | `Expression` |
| `regex_pattern` | string |  | `Regex_pattern` |
| `substituted_outputs` | text |  |  |

### Inputs

- `Expression` (`string`, required)
- `Regex_pattern` (`string`, required)
- `Match` (`string`)

### Outputs

- `Match` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## RemoteExecution

- **Display name**: Remote execution
- **Category**: Integration
- **Version**: 1.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides the ability to execute scripts or executables on remote nodes via SSH, with support for dynamic input variables and custom output extraction.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `command` | text |  |  |
| `execution_node` | string |  | `Execution_node` |
| `execution_login` | string |  |  |
| `execution_password` | string |  |  |
| `script_timeout` | integer |  |  |
| `report_stdio` | integer |  |  |
| `report_stderr` | integer |  |  |
| `formatted_outputs` | text |  |  |
| `formatted_outputs_processing_code` | text |  |  |
| `execution_server_address` | string |  | `Execution_server_address` |
| `use_server_address` | boolean |  |  |
| `should_cancel` | boolean |  |  |
| `return_stdio` | boolean |  |  |
| `keepalive` | boolean | `true` |  |
| `multi_line` | boolean |  |  |
| `mandatory_inputs` | text |  |  |
| `optional_inputs` | text |  |  |

### Inputs

- `Execution_node` (`string`, required)
- `Execution_server_address` (`string`, required)
- `Execution_login` (`string`)
- `Execution_password` (`string`)

### Outputs

- `exit_code` (`int`)
- `Multi` (`array`)
- `stdio` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## RemoteFileOperation

- **Display name**: Remote file operation
- **Category**: File Operations
- **Version**: 0.3.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to execute file operations (copy, move, delete, makedir, dir list) on remote nodes using Aspera transfer servers.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `operation` | string |  | `operation` |
| `source` | string |  | `Source` |
| `target` | string |  | `target` |
| `remote_node` | string |  | `remote_node` |
| `remote_node_user` | string |  |  |
| `remote_node_password` | string |  |  |
| `base` | string |  | `base` |
| `force_overwrite` | boolean |  |  |

### Inputs

- `remote_node` (`string`, required)
- `target` (`string`, required)
- `base` (`string`, optional)
- `operation` (`string`, required)
- `Source` (`string`, required)
- `remote_node_user` (`string`)
- `remote_node_password` (`string`)
- `source` (`array`)

### Outputs

- `Directory_list` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## RemoteFileWatcher

- **Display name**: Remote file watcher
- **Category**: Triggers
- **Version**: 2.4.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to wait for the arrival of files matching a certain pattern on a remote aspera server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `watch_directory` | text |  |  |
| `file_pattern` | string |  |  |
| `remote_node` | string |  |  |
| `remote_node_user` | string |  |  |
| `remote_node_password` | string |  |  |
| `polling_frequency` | integer | `10` (code) |  |
| `check_once` | boolean |  |  |
| `keep_ongoing` | boolean |  |  |
| `trigger_type` | string | `TRIG_GROUP` (code) |  |
| `return_single` | boolean |  |  |
| `trigger_on_partial` | boolean |  |  |
| `ignore_folders` | boolean |  |  |
| `ignore_instant_files` | boolean | `false` | `Ignore_instant_files` |
| `scan_timeout` | integer | `30` (code) |  |
| `ignore_zero_byte_files` | boolean | `false` |  |
| `multi_folders` | boolean | `false` |  |
| `recursive_search` | boolean | `false` | `Recursive_search` |
| `extensive_debug` | boolean | `false` |  |
| `force_exact_matching` | boolean | `false` | `Force_exact_matching` |
| `cool_off` | integer |  |  |
| `result_limit` | integer | `0` | `Result_limit` |
| `exclusions` | string |  | `Exclusions` |
| `ignore_ctime` | boolean | `false` |  |
| `aggressive_pruning` | boolean | `false` |  |
| `beacon_file_path` | string |  |  |

### Inputs

- `Ignore_instant_files` (`flag`, optional)
- `Recursive_search` (`flag`, optional)
- `Force_exact_matching` (`flag`, optional)
- `Result_limit` (`int`, optional)
- `Exclusions` (`string`, optional)
- `remote_node_user` (`string`)
- `remote_node_password` (`string`)
- `File_list` (`array`)
- `File_path` (`string`)
- `File_pattern` (`string`)
- `polling_frequency` (`int`)
- `persistence_scope` (`string`)
- `remote_node` (`string`)

### Outputs

- `File_list` (`array`)
- `File_path` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## RemoteFolderWatcher

- **Display name**: Remote folder watcher
- **Category**: Triggers
- **Version**: 0.2.4 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to wait for the arrival of a folder matching a certain pattern on a remote aspera server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `watch_directory` | string |  |  |
| `folder_pattern` | string |  |  |
| `remote_node` | string |  |  |
| `remote_node_user` | string |  |  |
| `remote_node_password` | string |  |  |
| `polling_frequency` | integer | `10` (code) |  |
| `check_once` | boolean |  |  |
| `keep_ongoing` | boolean |  |  |
| `trigger_type` | string | `TRIG_GROUP` (code) |  |
| `return_single` | boolean |  |  |
| `multi_folders` | boolean |  |  |
| `trigger_on_partial` | boolean |  |  |
| `force_exact_matching` | boolean | `false` (code) |  |
| `result_limit` | integer | `0` (code) | `Result_limit` |
| `scan_timeout` | integer | `60` (code) |  |
| `extensive_debug` | boolean |  |  |
| `cool_off` | integer |  |  |
| `partial_regex` | string |  |  |
| `ignore_empty_folders` | boolean | `true` (code) |  |
| `ignore_file_addition` | boolean | `false` |  |

### Inputs

- `Result_limit` (`int`, optional)
- `remote_node_user` (`string`)
- `remote_node_password` (`string`)
- `Folder_path` (`string`)
- `Folder_list` (`array`)
- `Folder_pattern` (`string`)
- `polling_frequency` (`int`)
- `persistence_scope` (`string`)
- `remote_node` (`string`)

### Outputs

- `Folder_path` (`string`)
- `Folder_list` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## ResourceManager

- **Display name**: Resource manager
- **Category**: Other Utilities
- **Version**: 2.3.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in is a tool to manage a limited pool of resources. It provides a way to pause a workflow until the resource becomes available.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `command` | text |  |  |
| `max_resources` | integer |  |  |
| `resource_list` | text |  |  |
| `unique_id` | string |  | `Unique_id` |
| `unicity_type` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `keep_ongoing` | boolean |  |  |
| `resource_wait_timeout` | integer |  |  |
| `resource_hold_timeout` | integer |  |  |
| `return_token_path` | boolean |  |  |
| `queue_id` | string |  | `Queue_id` |
| `is_adhoc` | boolean | `true` |  |
| `pool_name` | string |  | `Pool_name` |
| `operation` | string |  |  |
| `filter_outputs` | text |  |  |
| `mandatory_inputs` | text |  |  |
| `optional_inputs` | text |  |  |

### Inputs

- `Unique_id` (`string`, required)
- `Pool_name` (`string`, required)
- `Queue_id` (`string`, required)
- `Resource_token_path_to_release` (`string`)
- `Resource_name` (`string`)
- `Resource_to_release` (`string`)
- `Maximum_resources` (`int`)
- `Resource_list` (`array`)
- `Expected_queued_item` (`string`)

### Outputs

- `Resource_ID` (`string`)
- `Token_path` (`string`)
- `Queued_item` (`string`)
- `Queued_item_description` (`string`)
- `Resource_token_path_to_release` (`string`)
- `Resource_name` (`string`)
- `Resource_to_release` (`string`)
- `Maximum_resources` (`int`)
- `Resource_list` (`array`)
- `Expected_queued_item` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## RestRequest

- **Display name**: REST request
- **Category**: Integration
- **Version**: 1.2.4 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin allows you to make REST requests to web services, either as a one-time operation or with repeated polling at specified intervals.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `service_url` | string |  | `Service_url` |
| `rest_method` | string |  |  |
| `basic_auth_login` | string |  | `Basic_auth_login` |
| `basic_auth_password` | string |  | `Basic_auth_password` |
| `post_parameters` | text | `{}` (code) | `Post_parameters` |
| `post_body` | text | `` (code) | `Post_body` |
| `response_type` | string |  | `Response_type` |
| `processed_outputs` | text |  |  |
| `processed_outputs_code` | text | `` (code) | `Processed_outputs_code` |
| `http_form_post_mode` | boolean |  |  |
| `header_parameters` | text | `{}` (code) | `Header_parameters` |
| `content_type` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `max_records` | integer | `0` (code) |  |
| `keep_ongoing` | boolean |  |  |
| `polling_stop_condition` | text | `true` (code) | `Polling_stop_condition` |
| `record_identification_code` | text | `return record.to_yaml[3..-1]` (code) |  |
| `records_extracting_code` | text | `return [result]` (code) | `Records_extracting_code` |
| `record_formatting_code` | text |  | `Record_formatting_code` |
| `proxy_address` | text | `` (code) | `Proxy_address` |
| `save_to_file` | boolean | `false` | `Save_to_file` |
| `response_file_path` | text |  | `Response_file_path` |
| `ssl_verification` | boolean | `true` | `Ssl_verification` |
| `ssl_client_cert_path` | text |  | `Ssl_client_cert_path` |
| `ssl_client_key_path` | text |  | `Ssl_client_key_path` |
| `client_key_passphrase` | text |  | `Client_key_passphrase` |
| `ssl_ca_file_path` | text |  | `Ssl_ca_file_path` |
| `request_timeout` | integer |  | `Request_timeout` |
| `return_code_for_network_failure` | integer | `-1` (code) | `Return_code_for_network_failure` |
| `read_post_body_from_file` | boolean |  |  |
| `post_body_file_path` | string |  |  |
| `ssl_version` | string |  | `Ssl_version` |

### Inputs

- `Service_url` (`string`, required)
- `Basic_auth_login` (`string`, optional)
- `Basic_auth_password` (`string`, optional)
- `Header_parameters` (`string`, optional)
- `Processed_outputs_code` (`string`, optional)
- `Polling_stop_condition` (`string`, optional)
- `Records_extracting_code` (`string`, optional)
- `Record_formatting_code` (`string`, optional)
- `Proxy_address` (`string`, optional)
- `Ssl_client_cert_path` (`string`, optional)
- `Ssl_client_key_path` (`string`, optional)
- `Client_key_passphrase` (`string`, optional)
- `Ssl_ca_file_path` (`string`, optional)
- `Ssl_verification` (`flag`, required)
- `Ssl_version` (`string`, optional)
- `Request_timeout` (`int`, optional)
- `Response_type` (`string`, required)
- `Return_code_for_network_failure` (`int`, optional)
- `Post_parameters` (`string`, optional)
- `Post_body` (`string`, optional)
- `Save_to_file` (`flag`, optional)
- `Response_file_path` (`string`, required)
- `PUT_file_path` (`string`)
- `Post_body_file_path` (`string`)
- `Rest_Method` (`string`)

### Outputs

- `HTTP_return_code` (`int`)
- `Service_result` (`string`)
- `Formatted_result` (`array`)
- `JSON_result` (`hash`)
- `XML_result` (`hash`)
- `result_hash` (`hash`)
- `Response_in_a_file` (`string`)
- `Response_header` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## RobocopyOperation

- **Display name**: Robocopy
- **Category**: File Transfer
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides file copy operation on a Windows OS

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execution_node` | string |  | `Execution_node` |
| `execution_login` | string |  | `Execution_login` |
| `execution_password` | string |  | `Execution_password` |
| `binary_path` | string |  | `Binary_path` |
| `input_folder_path` | string |  | `Input_folder_path` |
| `output_folder_path` | string |  | `Output_folder_path` |
| `input_files` | string | `` (code) |  |
| `subdirectories_copy` | boolean | `false` (code) | `Subdirectories_copy` |
| `empty_directories_copy` | boolean | `false` (code) | `Empty_directories_copy` |
| `delete_from_source` | boolean | `false` (code) | `Delete_from_source` |
| `options` | text | `` (code) |  |

### Inputs

- `Input_folder_path` (`string`, required)
- `Output_folder_path` (`string`, required)
- `Binary_path` (`string`, required)
- `Delete_from_source` (`flag`, optional)
- `Subdirectories_copy` (`flag`, optional)
- `Empty_directories_copy` (`flag`, optional)
- `Execution_node` (`string`, optional)
- `Execution_login` (`string`, optional)
- `Execution_password` (`string`, optional)
- `files_tranferred` (`array`)
- `transfer_report` (`string`)
- `transfer_speed` (`array`)
- `new_directories_transferred` (`array`)

### Outputs

- `files_tranferred` (`array`)
- `transfer_report` (`string`)
- `transfer_speed` (`array`)
- `new_directories_transferred` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## RssFeedReader

- **Display name**: RSS Feed Reader
- **Category**: User Interactions
- **Version**: 0.5.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to read an RSS feed and can be used as a trigger.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `rss_url` | string |  | `Rss_url` |
| `post_id_field` | string |  | `Post_id_field` |
| `keep_ongoing` | boolean |  |  |
| `polling_frequency` | integer | `60` (code) |  |
| `return_all` | boolean |  |  |
| `additional_output_fields` | text |  |  |
| `return_post_xml` | boolean |  |  |
| `additional_output_extraction_code` | text |  |  |
| `trigger_type` | text |  |  |
| `do_validation` | boolean | `1` | `Do_validation` |
| `new_only` | boolean | `false` (code) | `New_only` |
| `use_simplerss` | boolean | `false` (code) |  |
| `ignore_ssl_validation` | boolean |  |  |

### Inputs

- `Rss_url` (`string`, required)
- `Post_id_field` (`string`, optional)
- `Do_validation` (`flag`, optional)
- `New_only` (`flag`, optional)
- `Title` (`string`)
- `Link` (`string`)
- `Description` (`string`)
- `Post_ID` (`string`)
- `All_posts` (`array`)
- `Post_XML` (`string`)
- `Item_keys` (`array`)

### Outputs

- `Title` (`string`)
- `Link` (`string`)
- `Description` (`string`)
- `Post_ID` (`string`)
- `All_posts` (`array`)
- `Post_XML` (`string`)
- `Item_keys` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## ScheduleTrigger

- **Display name**: Schedule trigger
- **Category**: Triggers
- **Version**: 1.2.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-ins provide the ability schedule the triggering of the following steps in a Workflow.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `allow_multiple` | boolean |  |  |
| `schedule_rules` | text |  | `schedule_rules` |
| `calendar_mode` | boolean |  |  |
| `trigger_start` | datetime | `DateTime.new(0)` (code) |  |
| `trigger_end` | datetime |  |  |
| `calculate_only` | boolean |  |  |

### Inputs

- `schedule_rules` (`string`, required)
- `keep_ongoing` (`flag`)
- `trigger_start` (`date`)
- `trigger_end` (`date`)

### Outputs

- `scheduled_trigger_time` (`date`)
- `trigger_time` (`date`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## ScomNotification

- **Display name**: SCOM notification
- **Category**: User Interactions
- **Version**: 1.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plugin provide the ability to submit log entry to the Windows Event Log. The execution can only occur on a windows host.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `code` | integer |  |  |
| `message` | text | `Aspera::Orchestrator: <% = EventMessage %>` (code) |  |

### Inputs

- `MessageCode` (`int`)

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## ScpTransfer

- **Display name**: SCP transfer
- **Category**: File Transfer
- **Version**: 0.2.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action enables uploading or downloading files and directories to or from a remote host using SCP (secure copy protocol over SSH).

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  | `Operation` |
| `remote_node` | string |  |  |
| `remote_address` | string |  |  |
| `remote_port` | string |  | `Remote_port` |
| `remote_user` | string |  | `Remote_user` |
| `remote_password` | string |  |  |
| `remote_key_location` | string |  | `Remote_key_location` |
| `local_path` | string |  | `Local_path` |
| `remote_path` | string |  | `Remote_path` |
| `remove_source_file` | boolean |  |  |
| `base` | string |  |  |
| `preserve_timestamps` | boolean |  |  |
| `recursive` | boolean |  |  |
| `reporting_increment` | integer | `5` (code) |  |

### Inputs

- `Operation` (`string`, required)
- `Local_path` (`string`, required)
- `Remote_path` (`string`, required)
- `Remote_user` (`string`, optional)
- `Remote_port` (`string`, optional)
- `Remote_key_location` (`string`, optional)
- `Remote_node_or_address` (`string`)
- `Remote_password` (`string`)

### Outputs

- `Transferred_files` (`array`)
- `Transferred_bytes` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## SftpTransfer

- **Display name**: SFTP transfer
- **Category**: File Transfer
- **Version**: 0.7.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides secure file transfer functionality to SFTP servers, supporting uploads, downloads, and deletions with flexible authentication options, proxy support, and specialized operations for handling large files and directory structures.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `remote_node` | string |  |  |
| `remote_address` | string |  |  |
| `remote_port` | integer | `22` (code) | `Remote_port` |
| `remote_user` | string |  | `Remote_user` |
| `remote_passphrase` | string |  |  |
| `remote_key_location` | string |  | `Remote_key_location` |
| `local_path` | string |  |  |
| `remote_path` | string |  |  |
| `remove_source_file` | boolean | `false` (code) |  |
| `preserve_timestamps` | boolean | `false` (code) |  |
| `reporting_frequency` | integer | `5` (code) |  |
| `proxy_host` | string |  |  |
| `proxy_port` | integer |  |  |
| `proxy_user` | string |  |  |
| `proxy_password` | string |  |  |
| `overwrite` | boolean | `false` (code) |  |
| `source_base` | string |  |  |
| `legacy_compatibility_mode` | boolean |  |  |
| `keepalive` | boolean |  |  |

### Inputs

- `Remote_user` (`string`, optional)
- `Remote_port` (`int`, optional)
- `Remote_key_location` (`string`, optional)
- `Remote_node_or_address` (`string`)
- `Upload_or_Download` (`string`)
- `Overwrite` (`flag`)
- `Remove_source_file` (`flag`)

### Outputs

- `Transferred_files` (`array`)
- `Transferred_bytes` (`int`)
- `Failed_files` (`hash`)
- `Remote_node_or_address` (`string`)
- `Upload_or_Download` (`string`)
- `Overwrite` (`flag`)
- `Remove_source_file` (`flag`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## SftpTrigger

- **Display name**: SFTP trigger
- **Category**: Triggers
- **Version**: 0.4.3 (requires Orchestrator 4.1.6 or later)
- **Description**: Enables hot folder functionality on a remote server using SFTP for automated file transfers.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `remote_node` | string |  |  |
| `remote_address` | string |  |  |
| `remote_port` | integer |  | `Remote_port` |
| `remote_user` | string |  | `Remote_user` |
| `remote_passphrase` | string |  | `Remote_passphrase` |
| `remote_key_location` | string |  | `Remote_key_location` |
| `watch_folder` | string |  | `Watch_folder` |
| `file_pattern` | string | `.*` (code) | `File_pattern` |
| `return_all` | boolean |  |  |
| `trigger_on_partial` | boolean |  |  |
| `polling_frequency` | integer | `30` (code) |  |
| `proxy_host` | string |  |  |
| `proxy_port` | string |  |  |
| `proxy_user` | string |  |  |
| `proxy_password` | string |  |  |
| `keep_ongoing` | boolean |  |  |
| `trigger_type` | string |  |  |
| `scan_once` | boolean |  |  |
| `cool_off` | integer |  |  |
| `recursion_depth` | integer | `0` (code) | `Recursion_depth` |

### Inputs

- `Watch_folder` (`string`, required)
- `File_pattern` (`string`, optional)
- `Recursion_depth` (`int`, optional)
- `Remote_user` (`string`, optional)
- `Remote_port` (`int`, optional)
- `Remote_key_location` (`string`, optional)
- `Remote_passphrase` (`string`, optional)
- `Polling_frequency` (`int`)
- `Persistence_scope` (`string`)
- `Remote_node_or_address` (`string`)

### Outputs

- `Files_found` (`array`)
- `File_found` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## SglFlashnetArchive

- **Display name**: SglFlashnetArchive
- **Category**: File Operations
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plug-in proivdes capability to perform rest operation on CatDV server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `sgl_node_address` | string |  | `Sgl_node_address` |
| `sgl_node_port` | integer |  | `Sgl_node_port` |
| `polling_frequency` | integer |  |  |
| `api_version` | string | `2013.001` (code) | `Api_version` |
| `source_server` | string |  |  |
| `user_name` | string |  | `User_name` |
| `calling_application` | string |  | `Calling_application` |
| `operation` | string |  | `Operation` |
| `mandatory_attributes` | string |  |  |
| `optional_attributes` | string |  |  |
| `file_name` | string |  |  |
| `file_guid` | string |  |  |
| `file_attributes` | string |  |  |
| `request_xml` | text |  |  |
| `request_xml_file` | string |  |  |
| `saved_inputs` | text |  |  |

### Inputs

- `Api_version` (`string`, optional)
- `User_name` (`string`, required)
- `Calling_application` (`string`, required)
- `Operation` (`string`, required)
- `Sgl_node_address` (`string`, required)
- `Sgl_node_port` (`int`, required)

### Outputs

- `Errors` (`array`)
- `Status` (`string`)
- `RequestId` (`string`)
- `Output_file` (`array`)
- `Job_status` (`string`)
- `Exit_Code` (`string`)
- `Error_code` (`string`)
- `Job_status_info` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## SharedStateOperation

- **Display name**: Shared state operation
- **Category**: Other Utilities
- **Version**: 0.5.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in can be used to create and retrive shared state objects.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `entry` | text |  | `entry` |
| `entry_name` | string |  | `entry_name` |
| `path` | string |  | `path` |
| `full_path` | string |  | `full_path` |
| `aggregate_type` | string |  | `aggregate_type` |
| `aggregate_id` | integer |  |  |
| `name` | string |  |  |
| `query_result` | string |  |  |
| `operation_retrieve` | boolean |  |  |
| `operation_create` | boolean |  |  |
| `retrieve_multiple` | boolean |  |  |
| `shared_state_id` | integer |  |  |
| `entry_type` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |

### Inputs

- `full_path` (`string`, optional)
- `aggregate_type` (`string`, optional)
- `entry` (`string` or `<entry_type>`, required)
- `path` (`string`, optional)
- `entry_name` (`string`, optional)
- `aggregate_id` (`int`)
- `shared_state_id` (`int`)

### Outputs

- `id` (`int`)
- `entry` (`<entry_type>`)
- `entry_type` (`string`)
- `path` (`string`)
- `name` (`string`)
- `aggregate_type` (`string`)
- `aggregate_id` (`int`)
- `Shared state(s)` (`array`)
- `Number of shared states retrieved` (`int`)
- `Errors` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- A name in angle brackets (`<attribute>`) is the value of that template attribute.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## SharesTransferSetup

- **Display name**: Shares transfer setup
- **Category**: File Transfer
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin returns the transfer specification to be used for Node API-based transfers to/from a Share defined with Aspera Shares.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `remote_node` | string |  | `Remote_node` |
| `server_address` | string |  | `remote node or server address` |
| `server_port` | integer | `443` (code) |  |
| `source` | string |  | `source` |
| `destination_folder` | string |  | `destination folder` |
| `destination_filename` | string |  | `destination filename` |
| `direction` | string | `send` (code) | `direction` |
| `username` | string |  | `user name` |
| `password` | string |  | `password` |

### Inputs

- `remote node or server address` (`string`, required)
- `user name` (`string`, required)
- `password` (`string`, required)
- `Remote_node` (`string`, required)
- `source` (`string`, required)
- `destination folder` (`string`, required)
- `destination filename` (`string`, optional)
- `direction` (`string`, optional)

### Outputs

- `transfer_spec` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## ShowMgrOperation

- **Display name**: ShowMgr
- **Category**: Asset Management
- **Version**: 0.2.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-ins is used to interact with ShowMgr (using API calls)

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `subscription_key` | text |  | `Subscription_key` |
| `api_operation` | string |  |  |
| `order_class` | string |  |  |
| `order_fetch_status` | string |  |  |
| `order_id` | string |  | `Order_id` |
| `order_update_status` | string |  |  |
| `keep_ongoing` | boolean |  |  |
| `trigger_type` | string |  |  |
| `service_url` | string | `https://api.showmgr.com/sony-qc/Order` (code) |  |

### Inputs

- `Subscription_key` (`string`, required)
- `Order_id` (`string`, required)
- `Order_Info` (`hash`)
- `Order_Id` (`string`)
- `Job Status` (`string`)
- `File Location` (`string`)
- `Error` (`string`)
- `Orders_list` (`array`)
- `Execution Report` (`string`)
- `Order Status` (`string`)

### Outputs

- `Order_Info` (`hash`)
- `Order_Id` (`string`)
- `Job Status` (`string`)
- `File Location` (`string`)
- `Error` (`string`)
- `Orders_list` (`array`)
- `Execution Report` (`string`)
- `Order Status` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## SimpleParameterLookup

- **Display name**: Look-up table
- **Category**: Other Utilities
- **Version**: 0.8.8 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides a framework to associate miscellaneous values to parameters at design time and retrieve these associated values at runtime based on input parameter values.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `case_sensitive` | boolean | `false` (code) |  |
| `strip_spaces` | boolean | `false` (code) |  |
| `disable_glob` | boolean |  |  |
| `disable_regex` | boolean |  |  |
| `comments` | text |  |  |
| `support_typed_outputs` | boolean |  |  |
| `return_array_of_rows` | boolean | `false` |  |
| `mapping_parameters` | string |  |  |
| `parameters_associations` | text |  |  |
| `param_file_name` | string |  |  |

### Inputs

- `ColumnValues` (`array`)
- `IndexedTable` (`hash`)
- `ColumnToListValueFrom` (`string`)
- `KeyForTableIndexing` (`string`)
- `Keys` (`array`)
- `Values` (`array`)
- `rows` (`array`)
- `ValuesHash` (`hash`)

### Outputs

- `ColumnValues` (`array`)
- `IndexedTable` (`hash`)
- `rows` (`array`)
- `ValuesHash` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## SlackNotification

- **Display name**: Slack notification
- **Category**: User Interactions
- **Version**: 0.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to interact with Slack

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `slack_url` | string |  | `Slack_url` |
| `token` | string |  | `Token` |
| `channel` | string |  | `Channel` |
| `text_message` | text |  | `Text_message` |
| `as_user` | boolean | `false` (code) | `As_user` |
| `username` | string |  | `Username` |
| `upload_content` | boolean |  |  |
| `upload_file` | string |  |  |
| `title` | string |  |  |
| `upload_filename` | string |  |  |
| `initial_comment` | string |  |  |
| `verify_ssl` | boolean | `false` (code) |  |
| `attachments` | text | `` (code) | `Attachments` |

### Inputs

- `Token` (`string`, required)
- `Slack_url` (`string`, required)
- `Channel` (`string`, required)
- `Text_message` (`string`, required)
- `As_user` (`flag`, optional)
- `Username` (`string`, optional)
- `Attachments` (`string`, optional)

### Outputs

- `Error_Message` (`string`)
- `Auth_Response_Received` (`hash`)
- `Team_Id` (`string`)
- `Team_Name` (`string`)
- `Company_Url` (`string`)
- `Send_Text_Response` (`hash`)
- `TS_Value` (`string`)
- `Step_information` (`hash`)

## SnapshotPlugin

- **Display name**: Snapshot
- **Category**: System
- **Version**: 0.2.1 (requires Orchestrator 4.1.6 or later)
- **Description**: Takes a snapshot of the Orchestrator configuration.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text | `"Snapshot of Orchestrator configuration as of` (code) |  |
| `snapshot_name` | string | `"Snapshot_` (code) | `Snapshot_name` |
| `snapshot_directory` | string | `config.archive_dir` (code) | `Snapshot_directory` |
| `custom_tables` | text | `` (code) |  |
| `export_full_db` | boolean | `false` |  |
| `db_export_directory` | string |  |  |

### Inputs

- `Snapshot_name` (`string`, optional)
- `Snapshot_directory` (`string`, optional)
- `Db_export_path` (`string`)

### Outputs

- `Snapshot_path` (`string`)
- `Db_export_path` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## SoapRequest

- **Display name**: Soap request
- **Category**: Integration
- **Version**: 2.1.7 (requires Orchestrator 4.1.6 or later)
- **Description**: This plug-in provides the ability to periodically execute a SOAP query on a web service. It can be used for a one-off request or as a polling mechanism.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `wsdl_uri` | string |  | `Wsdl_uri` |
| `local_wsdl_path` | string |  |  |
| `service_node` | string |  |  |
| `service_host` | string |  |  |
| `use_ssl` | boolean |  |  |
| `service_port` | string |  |  |
| `service_path` | string |  |  |
| `service_action` | string |  | `Service_action` |
| `session_header_hash` | text |  |  |
| `session_parameters_hash` | text |  |  |
| `polling_stop_condition` | text | `true` (code) | `Polling_stop_condition` |
| `records_extracting_code` | text | `return [rpc_result]` (code) | `Records_extracting_code` |
| `record_formatting_code` | text |  | `Record_formatting_code` |
| `result_formatting_code` | text |  | `Result_formatting_code` |
| `result_type` | string |  |  |
| `polling_frequency` | integer | `0` (code) |  |
| `max_records` | integer | `0` (code) |  |
| `keep_ongoing` | boolean |  |  |
| `record_identification_code` | text | `return record.to_yaml[3..-1]` (code) |  |
| `explicit_payload_mode` | boolean |  |  |
| `explicit_payload` | text |  | `Explicit_payload` |
| `explicit_endpoint` | string |  | `Explicit_endpoint` |
| `explicit_soap_action` | string |  | `Explicit_soap_action` |
| `return_raw_response` | boolean |  |  |
| `return_response_body` | boolean |  |  |
| `http_basic_auth_user` | string |  | `Http_basic_auth_user` |
| `http_basic_auth_password` | string |  | `Http_basic_auth_password` |
| `http_timeout` | integer | `60` (code) |  |
| `return_status` | boolean | `false` (code) |  |
| `soap_debug_mode` | boolean | `false` |  |
| `use_legacy_xml` | boolean | `false` |  |

### Inputs

- `Polling_stop_condition` (`string`, optional)
- `Records_extracting_code` (`string`, optional)
- `Record_formatting_code` (`string`, optional)
- `Result_formatting_code` (`string`, optional)
- `Explicit_endpoint` (`string`, optional)
- `Explicit_soap_action` (`string`, optional)
- `Wsdl_uri` (`string`, required)
- `Service_action` (`string`, required)
- `Explicit_payload` (`string`, required)
- `Http_basic_auth_user` (`string`, optional)
- `Http_basic_auth_password` (`string`, optional)
- `Session_header_parameters` (`hash`)
- `Service_parameters` (`hash`)
- `Cookie` (`string`)

### Outputs

- `Raw_response` (`string`)
- `Response_body` (`hash`)
- `Cookie` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## SoapRequestListener

- **Display name**: Soap request listener
- **Category**: Triggers
- **Version**: 0.2.4 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-ins provides the ability wait for a SOAP message and extract its content.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `callback_id_mode` | string |  |  |
| `id_preset_value` | string |  |  |
| `authentication_type` | string |  |  |
| `authentication_mode` | string |  |  |
| `polling_frequency` | integer | `5` (code) |  |
| `keep_ongoing` | boolean |  |  |
| `processed_outputs` | text |  |  |
| `processed_outputs_code` | text | `` (code) |  |

### Inputs

- `Run-time call back ID` (`string`)

### Outputs

- `Remote_address` (`string`)
- `XML_payload` (`string`)
- `Header` (`hash`)
- `Body` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## SoftlayerApi

- **Display name**: Softlayer API
- **Category**: Integration
- **Version**: 0.2.3 (requires Orchestrator 4.1.6 or later)
- **Description**: Integration with Softlayer API

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `softlayer_url` | string |  |  |
| `softlayer_service` | string |  |  |
| `softlayer_method` | string |  | `Softlayer_method` |
| `softlayer_initparam` | string | `` (code) | `Softlayer_initparam` |
| `username` | string |  | `Username` |
| `apikey` | string |  | `Apikey` |
| `rest_method` | string |  |  |
| `response_type` | string | `json` (code) |  |
| `ssl_verification` | boolean | `false` (code) |  |
| `object_mask` | text | `[]` (code) | `Object_mask` |
| `object_filter` | text | `` (code) | `Object_filter` |
| `proxy_address` | string | `` (code) | `Proxy_address` |
| `post_body` | text | `` (code) | `Post_body` |
| `request_timeout` | integer |  | `Request_timeout` |
| `processed_outputs` | text |  |  |
| `processed_outputs_code` | text | `` (code) |  |
| `keep_ongoing` | boolean |  |  |
| `polling_frequency` | integer | `0` (code) |  |
| `polling_stop_condition` | text |  |  |
| `result_limit` | integer | `0` (code) | `Result_limit` |
| `result_offset` | integer | `0` (code) | `Result_offset` |

### Inputs

- `Username` (`string`, required)
- `Apikey` (`string`, required)
- `Proxy_address` (`string`, optional)
- `Object_mask` (`string`, optional)
- `Object_filter` (`string`, optional)
- `Request_timeout` (`int`, optional)
- `Softlayer_method` (`string`, required)
- `Post_body` (`string`, optional)
- `Softlayer_initparam` (`string`, optional)
- `Result_limit` (`int`, optional)
- `Result_offset` (`int`, optional)

### Outputs

- `HTTP_return_code` (`int`)
- `Service_result` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## SonyCi

- **Display name**: Sony Ci
- **Category**: Asset Management
- **Version**: 0.2.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin enables management of media assets within Sony Ci cloud platform through upload, download, and metadata operations.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `username` | string |  | `Username` |
| `password` | string |  | `Password` |
| `client_id` | string |  | `Client_id` |
| `client_secret` | string |  | `Client_secret` |
| `workspace_id` | string | `` (code) | `Workspace_id` |
| `folder_id` | string | `` (code) | `Folder_id` |
| `filesize` | integer | `1` (code) | `Filesize` |
| `filepath` | string |  | `Filepath` |
| `operation` | string |  |  |
| `asset_id` | string |  | `Asset_id` |
| `download_folder` | string |  | `Download_folder` |
| `parameters` | text |  | `Parameters` |

### Inputs

- `Username` (`string`, required)
- `Password` (`string`, required)
- `Client_id` (`string`, required)
- `Client_secret` (`string`, required)
- `Workspace_id` (`string`, optional)
- `Folder_id` (`string`, optional)
- `Filesize` (`int`, optional)
- `Filepath` (`string`, required)
- `Asset_id` (`string`, required)
- `Download_folder` (`string`, required)
- `Parameters` (`string`, required)

### Outputs

- `result_transfer_spec` (`string`)
- `asset_id` (`string`)
- `metadata` (`array`)
- `Step_information` (`hash`)

## SonyCiFileWatcher

- **Display name**: SonyCi file watcher
- **Category**: Triggers
- **Version**: 0.1.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin monitors Sony Ci folders for new files matching specified patterns and returns file information when matches are detected.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `username` | string |  | `Username` |
| `password` | string |  | `Password` |
| `client_id` | string |  | `Client_id` |
| `client_secret` | string |  | `Client_secret` |
| `folder_id` | string |  | `Folder_id` |
| `file_pattern` | string |  | `File_pattern` |
| `polling_frequency` | integer | `10` (code) |  |
| `keep_ongoing` | boolean |  |  |
| `return_single` | boolean |  |  |
| `check_once` | boolean |  |  |
| `trigger_type` | string | `TRIG_GROUP` (code) |  |

### Inputs

- `Username` (`string`, required)
- `Password` (`string`, required)
- `Client_id` (`string`, required)
- `Client_secret` (`string`, required)
- `Folder_id` (`string`, required)
- `File_pattern` (`string`, required)
- `File_info_list` (`array`)
- `File_info` (`hash`)

### Outputs

- `File_info_list` (`array`)
- `File_info` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## SpreadsheetParser

- **Display name**: Spreadsheet parser
- **Category**: File Operations
- **Version**: 0.2.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This plug-in allows workflows to read and process data from spreadsheet files such as Excel. It extracts the spreadsheet content into structured data that can be used in later steps.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `file_path` | string |  | `File_path` |
| `first_sheet_only` | boolean |  |  |
| `organize_by` | string |  |  |
| `index_by` | string |  |  |
| `drop_header_row` | boolean |  |  |
| `drop_header_col` | boolean |  |  |
| `typed_outputs` | text |  |  |
| `mark_warnings` | boolean | `false` |  |

### Inputs

- `File_path` (`string`, required)

### Outputs

- `First sheet` (`hash`)
- `Sheet name` (`string`)
- `Sheets` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## SubWorkflow

- **Display name**: Sub-workflow
- **Category**: System
- **Version**: 1.5.4 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in allows you to embed an entire, separately defined workflow as a single step within another workflow. This enables you to break down complex processes into manageable sub-workflows, making them easier to build, maintain, and reuse.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `workflow_id` | integer |  |  |
| `comments` | text |  |  |
| `name` | string |  |  |
| `exit_status_for_errors` | string | `ActionTools::STATUS_FAILED` (code) |  |
| `use_true_name` | boolean |  |  |
| `use_workorder_status` | boolean |  |  |
| `workflow_portable_id` | string |  |  |
| `execution_priority` | integer |  | `Execution_priority` |
| `workflow_outputs` | text |  |  |
| `workflow_inputs` | text |  |  |

### Inputs

- `Execution_priority` (`int`, optional)
- `Workflow_ID` (`int`)
- `Sub-Workflow_Input_Parameters` (`hash`)

### Outputs

- `Sub-Workflow_workorder_ID` (`int`)
- `Sub-Workflow_Outputs` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## SublerOperation

- **Display name**: Subler Operation
- **Category**: File Transformations
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to perform file transformation operations on a MAC System using the Subler toolset.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execution_node` | string |  | `Execution_node` |
| `execution_login` | string |  | `Execution_login` |
| `execution_password` | string |  | `Execution_password` |
| `binary_path` | string |  | `Binary_path` |
| `source_path` | string | `` (code) | `Source_path` |
| `destination_path` | string | `` (code) | `Destination_path` |
| `chapters_file_path` | string | `` (code) | `Chapters_file_path` |
| `source_options` | text | `` (code) | `Source Options` |
| `destination_options` | text | `` (code) | `Destination Options` |
| `options` | text | `` (code) | `Options` |
| `operation` | string |  |  |

### Inputs

- `Source Options` (`string`, optional)
- `Binary_path` (`string`, required)
- `Destination Options` (`string`, optional)
- `Options` (`string`, optional)
- `Destination_path` (`string`, optional)
- `Source_path` (`string`, optional)
- `Chapters_file_path` (`string`, optional)
- `Execution_node` (`string`, required)
- `Execution_login` (`string`, required)
- `Execution_password` (`string`, required)
- `Result_file_path` (`string`)
- `transformation_report` (`string`)
- `execution_output` (`string`)

### Outputs

- `Result_file_path` (`string`)
- `transformation_report` (`string`)
- `execution_output` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## SymantecIcapDlpOperation

- **Display name**: Symantec Icap DLP Operations
- **Category**: Virus Scan
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plugin is used to make a ICAP call to Symantec DLP Engine.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `service_ip` | string |  | `Service_ip` |
| `port` | integer |  | `Port` |
| `scan_type` | string |  | `Scan_type` |
| `sender_email` | string |  | `Sender_email` |
| `receiver_email` | string |  | `Receiver_email` |
| `file_name` | string |  | `File_name` |
| `timeout_sec` | integer |  | `Timeout_sec` |
| `log_file_path` | string | `` (code) | `Log_file_path` |

### Inputs

- `Service_ip` (`string`, required)
- `Port` (`int`, required)
- `Scan_type` (`string`, required)
- `Sender_email` (`string`, required)
- `Receiver_email` (`string`, required)
- `Timeout_sec` (`int`, required)
- `File_name` (`string`, required)
- `Log_file_path` (`string`, optional)

### Outputs

- `Raw_Execution_Output` (`string`)
- `Log_File_Path` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## SymantecIcapVirusScanOperation

- **Display name**: Symantec Icap Virus Scan Operations
- **Category**: Virus Scan
- **Version**: 0.4.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plugin is used to make a ICAP call to Symantec Antivirus Engine.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `service_ip` | string |  | `Service_ip` |
| `port` | integer |  | `Port` |
| `scan_type` | string |  | `Scan_type` |
| `send_size` | string | `` (code) | `Send_size` |
| `file_size` | string | `` (code) | `File_size` |
| `file_name` | string |  | `File_name` |
| `log_file_path` | string | `` (code) | `Log_file_path` |
| `is_encrypted` | boolean |  |  |
| `remote_node` | string |  | `Remote_node` |
| `is_remote_execution` | boolean |  |  |
| `remote_jar_path` | text |  | `Remote_jar_path` |
| `operation_type` | string |  |  |
| `scan_action` | string |  | `Scan_action` |
| `clobber` | boolean | `false` (code) | `Clobber` |
| `verbose` | boolean | `false` (code) | `Verbose` |
| `api_version` | string | `false` (code) | `Api_version` |
| `local_jar_path` | text |  | `Local_jar_path` |

### Inputs

- `Service_ip` (`string`, required)
- `Port` (`int`, required)
- `File_name` (`string`, required)
- `Scan_action` (`string`, required)
- `Clobber` (`flag`, optional)
- `Verbose` (`flag`, optional)
- `Api_version` (`string`, optional)
- `Local_jar_path` (`string`, required)
- `Scan_type` (`string`, required)
- `File_size` (`string`, optional)
- `Send_size` (`string`, optional)
- `Log_file_path` (`string`, optional)
- `Remote_node` (`string`, required)
- `Remote_jar_path` (`string`, required)

### Outputs

- `Raw_Execution_Output` (`string`)
- `Log_File_Path` (`string`)
- `Log_file_Content` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## SymantecPgp

- **Display name**: PGP encryption
- **Category**: File Operations
- **Version**: 0.4.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in can be used to encyrpt/decrypt programatically a file using the symantec pgp command line tool.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `source_file_path` | string |  |  |
| `passphrase` | string |  |  |
| `operation` | string |  |  |
| `target_file_path` | string |  |  |
| `execution_node` | string |  |  |
| `execution_login` | string |  |  |
| `execution_password` | string |  |  |
| `script_timeout` | integer |  |  |
| `pgp_binary_path` | string |  |  |
| `options` | string |  |  |
| `gpg_mode` | boolean |  |  |

### Inputs

- `target_file_path` (`string`)
- `source_file_path` (`string`)
- `passphrase` (`string`)
- `options` (`string`)
- `execution_node` (`string`)

### Outputs

- `processed_file_path` (`string`)
- `passphrase` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## ThePlatform

- **Display name**: The Platform
- **Category**: Asset Management
- **Version**: 0.4.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to create, read, and update thePlatform objects.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `username` | string |  | `username` |
| `password` | string |  | `password` |
| `account_name` | string |  | `Account_name` |
| `form_type` | string |  | `Form_type` |
| `object` | string |  | `Object` |
| `schema` | string |  | `Schema` |
| `operation` | string |  |  |
| `query_fields` | text |  |  |
| `sort_by` | text |  |  |
| `query_range_start` | string | `0` (code) | `Query_range_start` |
| `query_range_stop` | string | `500` (code) | `Query_range_stop` |
| `query_by` | text |  |  |
| `include_result_count` | boolean |  |  |
| `include_entries` | boolean |  |  |
| `include_owned` | boolean |  |  |
| `include_types` | boolean |  |  |
| `include_valid_feed` | boolean |  |  |
| `include_feed` | boolean |  |  |
| `include_pretty` | boolean |  |  |
| `account_url` | string |  | `Account_url` |
| `media_asset` | string |  | `Media_asset` |
| `source_url` | string |  | `Source_url` |
| `media_id_url` | string |  | `Media_id_url` |
| `token` | string |  |  |
| `theplatform_url` | string | `https://data.media.theplatform.com/media/data/` (code) |  |
| `authentication_url` | string | `https://identity.auth.theplatform.com/idm/web/Authentication/` (code) |  |
| `store_token` | boolean | `false` |  |

### Inputs

- `username` (`string`, required)
- `password` (`string`, required)
- `Account_name` (`string`, required)
- `Schema` (`string`, required)
- `Object` (`string`, required)
- `Form_type` (`string`, required)
- `Query_range_start` (`string`, optional)
- `Query_range_stop` (`string`, optional)
- `Account_url` (`string`, required)
- `Media_asset` (`string`, required)
- `Media_id_url` (`string`, required)
- `Source_url` (`string`, required)

### Outputs

- `ThePlatform_Token` (`string`)
- `Is_Token_Released` (`flag`)
- `Total_result_count` (`string`)
- `Create_result` (`hash` or `string`)
- `Media_Id_Url` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## ThreePlayOperation

- **Display name**: 3PlayMedia Operation
- **Category**: Other Utilities
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: Add description here

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `service_url` | text |  |  |
| `operation` | string |  |  |
| `apikey` | text |  | `Apikey` |
| `api_secret_key` | text |  | `Api_secret_key` |
| `link` | text |  | `Link` |
| `file` | string |  | `File` |
| `check_for_completion` | boolean |  |  |
| `check_for_download` | boolean |  |  |
| `batch_name` | string |  | `Batch_name` |
| `video_id` | string |  | `Video_id` |
| `turnaround_level` | string | `standard` (code) |  |
| `project_name` | string |  | `Project_name` |
| `account_name` | string |  | `Account_name` |
| `name_3play` | string |  | `Name_3play` |
| `attribute1` | string |  | `Attribute1` |
| `attribute2` | string |  | `Attribute2` |
| `batch_id` | string |  | `Batch_id` |
| `description_3play` | string |  | `Description_3play` |
| `attribute3` | string |  | `Attribute3` |
| `polling_frequency` | integer | `10` (code) |  |
| `starting_timecode_smpte` | string |  | `Starting_timecode_smpte` |
| `frames_per_second` | string |  | `Frames_per_second` |
| `drop_frame` | string |  | `Drop_frame` |
| `internal_id` | string |  | `Internal_id` |
| `format` | string |  | `Format` |

### Inputs

- `Apikey` (`string`, required)
- `Api_secret_key` (`string`, required)
- `Link` (`string`, required)
- `File` (`string`, optional)
- `Attribute1` (`string`, optional)
- `Attribute2` (`string`, optional)
- `Attribute3` (`string`, optional)
- `Batch_name` (`string`, optional)
- `Batch_id` (`string`, optional)
- `Video_id` (`string`, optional)
- `Description_3play` (`string`, required)
- `Account_name` (`string`, optional)
- `Project_name` (`string`, optional)
- `Name_3play` (`string`, optional)
- `Internal_id` (`string`, required)
- `Starting_timecode_smpte` (`string`, required)
- `Frames_per_second` (`string`, optional)
- `Drop_frame` (`string`, optional)
- `Format` (`string`, required)

### Outputs

- `Error_Message` (`string`)
- `Internal_Id` (`string`)
- `Raw_Output` (`string`)
- `Status` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## TimecodeManager

- **Display name**: Timecode manager
- **Category**: Transcoding
- **Version**: 0.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: Allows timecodes manipulations like conversions, sums or differences.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string | `CONVERT` (code) |  |
| `input_format` | string | `TIMECODE` (code) | `Input_format` |
| `frames_per_seconds` | string | `DEFAULT_FPS` (code) |  |
| `start_value` | string |  | `Start_value` |
| `first_frame_offset` | string | `0` (code) | `First_frame_offset` |
| `second_value` | string |  | `Second_value` |
| `only_get_frame_count` | boolean |  |  |

### Inputs

- `Start_value` (`string`, required)
- `First_frame_offset` (`string`, optional)
- `Input_format` (`string`, optional)
- `Second_value` (`string`, required)
- `Frames_per_seconds` (`string`)

### Outputs

- `frame_count` (`int`)
- `timecode` (`string`)
- `ms_count` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## UnifiedPackager

- **Display name**: Unified packager
- **Category**: Transcoding
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to create a server manifest file with mp4split tool.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execution_node` | string |  |  |
| `output_file_path` | string |  |  |
| `binary_path` | string | `mp4split` (code) |  |
| `license_path` | string | `` (code) |  |
| `options_before_output_file_path` | text | `` (code) |  |
| `options_after_output_file_path` | text | `` (code) |  |
| `input_files_data` | text | `` (code) |  |

### Inputs

- None found in source.

### Outputs

- `status_code` (`int`)
- `report` (`string`)
- `Step_information` (`hash`)

## UserInput

- **Display name**: User input
- **Category**: User Interactions
- **Version**: 0.8.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This plugin provides an interactive way to present information and collect data from users through web forms within the Orchestrator control application.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `event_description` | string | `` (code) | `Event_description` |
| `comments` | text |  |  |
| `assigned_roles` | string |  |  |
| `assigned_users` | string |  |  |
| `keep_ongoing` | boolean |  |  |
| `direct_url` | string |  |  |
| `email_notification` | boolean | `0` |  |
| `email_subject` | string |  | `Email_subject` |
| `email_body` | text |  | `Email_body` |
| `email_from_address` | string |  |  |
| `email_additional_to_addresses` | string |  | `Email_additional_to_addresses` |
| `email_additional_cc_addresses` | string |  | `Email_additional_cc_addresses` |
| `email_additional_bcc_addresses` | string |  | `Email_additional_bcc_addresses` |
| `mailer_name` | string |  |  |
| `required_requested_data` | text |  |  |
| `assigned_user_logins` | text |  |  |
| `assigned_roles_logins` | text |  |  |
| `expose_user_information` | boolean | `0` |  |
| `mandatory_inputs` | text |  |  |
| `optional_inputs` | text |  |  |
| `user_outputs` | text |  |  |
| `view_template` | string |  |  |

### Inputs

- `Email_subject` (`string`, required)
- `Email_body` (`string`, required)
- `Email_additional_to_addresses` (`string`, optional)
- `Email_additional_cc_addresses` (`string`, optional)
- `Email_additional_bcc_addresses` (`string`, optional)
- `Event_description` (`string`, optional)
- `UserAssignmentsArray` (`array`)
- `RoleAssignmentsArray` (`array`)
- `SingleUserAssignment` (`string`)
- `SingleRoleAssignment` (`string`)

### Outputs

- `ActiveAssignment::INPUT_PROVIDER_VAR` (`string`)
- `First name` (`string`)
- `Last name` (`string`)
- `Orchestrator login` (`string`)
- `Email address` (`string`)
- `Alternate email addresses` (`string`)
- `Full name` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## UserLookup

- **Display name**: User lookup
- **Category**: System
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to lookup the information about orchestrator users identified by ID, name, login or email address.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `lookup_by` | string |  |  |
| `enable_glob` | boolean |  |  |
| `return_all` | boolean |  |  |
| `include_inactive_users` | boolean |  |  |

### Inputs

- `<lookup_by>` (`int` or `string`)

### Outputs

- `Orchestrator user ID` (`int` or `array`)
- `First name` (`string` or `hash`)
- `Last name` (`string` or `hash`)
- `Orchestrator login` (`string` or `hash`)
- `Email address` (`string` or `hash`)
- `Phone number` (`string` or `hash`)
- `Active` (`flag` or `hash`)
- `Created` (`date` or `hash`)
- `Last updated` (`date` or `hash`)
- `User type` (`string` or `hash`)
- `Alternate email addresses` (`array` or `hash`)
- `Group memberships` (`array` or `hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- A name in angle brackets (`<attribute>`) is the value of that template attribute.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## UuidGenerator

- **Display name**: UUID Generator
- **Category**: Other Utilities
- **Version**: 0.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to generate unique ID formatted "39fa4e20-0f32-0132-d394-282066598c75".

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `compact` | boolean | `false` |  |
| `randomize` | boolean | `false` |  |

### Inputs

- None found in source.

### Outputs

- `UUID` (`string`)
- `Step_information` (`hash`)

## VantageTranscoding

- **Display name**: Vantage Transcoding
- **Category**: Transcoding
- **Version**: 1.0.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides the ability to submit file transcoding jobs to a Vantage server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server_node` | string |  | `Server_node` |
| `server_address` | string |  |  |
| `api_port` | string |  |  |
| `source_file` | string |  | `Source_file` |
| `workflow_id` | string |  | `Workflow_id` |
| `workflow_name` | string |  | `Workflow_name` |
| `job_name` | string |  | `Job_name` |
| `polling_frequency` | integer |  |  |
| `wf_items` | mediumtext |  |  |
| `api_method` | string |  | `Api_method` |
| `wf_variables` | mediumtext |  |  |
| `reuse_job_id` | boolean | `false` |  |
| `fail_if_cannot_restart` | boolean |  |  |

### Inputs

- `Job_name` (`string`, required)
- `Api_method` (`string`, required)
- `Workflow_id` (`string`, required)
- `Workflow_name` (`string`, required)
- `Server_node` (`string`, required)
- `Source_file` (`string`, required)
- `Var_#{v}` (`string`)
- `It_#{i}` (`string`)

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## VidcheckerVerification

- **Display name**: Vidchecker verification
- **Category**: Quality Control
- **Version**: 0.4.2 (requires Orchestrator 4.1.6 or later)
- **Description**: Executes and monitors quality control verifications on a VidChecker server.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `server_node` | string |  |  |
| `server_port` | string | `51060` (code) |  |
| `server_address` | string |  |  |
| `template_id` | string |  |  |
| `file_path` | string |  |  |
| `should_write_report` | boolean | `false` |  |
| `report_file_path` | string |  |  |
| `fail_on_warning` | boolean | `false` (code) |  |
| `polling_frequency` | integer | `5` (code) |  |
| `report_type` | string | `XML` (code) |  |

### Inputs

- `Service_node_or_address` (`string`)

### Outputs

- `Stream_info` (`hash`)
- `Alerts_count` (`int`)
- `Task_alerts` (`array`)
- `Task_info` (`hash`)
- `Job_id` (`string`)
- `Report_file_path` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## VqbifAnalyzer

- **Display name**: VqbifAnalyzer
- **Category**: Quality Control
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plug-in proivdes capability to execute Vqbif commands on a remote node.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execution_node` | string |  | `Execution_node` |
| `vqbif_binary_path` | string |  | `Vqbif_binary_path` |
| `input_file_path` | string |  | `Input_file_path` |
| `input_file_path_two` | string | `` (code) | `Input_file_path_two` |
| `input_file_path_three` | string | `` (code) | `Input_file_path_three` |
| `output_file_path` | string | `` (code) | `Output_file_path` |
| `jpeg_folder_path` | string | `` (code) | `Jpeg_folder_path` |
| `framewise_separation` | string | `` (code) | `Framewise_separation` |
| `review_mode` | string | `DEFAULT_MODE` (code) | `Review_mode` |

### Inputs

- `Input_file_path` (`string`, required)
- `Output_file_path` (`string`, optional)
- `Vqbif_binary_path` (`string`, required)
- `Execution_node` (`string`, required)
- `Jpeg_folder_path` (`string`, optional)
- `Review_mode` (`string`, optional)
- `Framewise_separation` (`string`, optional)
- `Input_file_path_two` (`string`, optional)
- `Input_file_path_three` (`string`, optional)

### Outputs

- `Output_File_Path` (`string`)
- `Transformation_Report` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## VqmaAnalyzer

- **Display name**: VqmaAnalyzer
- **Category**: Transcoding
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to submit and control a file transcoding operation using the HandBrake toolset.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `execution_node` | string |  | `Execution_node` |
| `vqma_binary_path` | string |  | `Vqma_binary_path` |
| `input_file_path` | string |  | `Input_file_path` |
| `output_file_path` | string | `` (code) | `Output_file_path` |
| `format` | string |  | `Format` |
| `hsize` | integer |  |  |
| `vsize` | integer |  |  |
| `options` | text | `` (code) |  |

### Inputs

- `Input_file_path` (`string`, required)
- `Output_file_path` (`string`, optional)
- `Vqma_binary_path` (`string`, required)
- `Execution_node` (`string`, required)
- `Format` (`string`, required)
- `Result_file_path` (`string`)
- `transformation_report` (`string`)

### Outputs

- `Result_file_path` (`string`)
- `transformation_report` (`string`)
- `Step_information` (`hash`)

## WatchFileMovement

- **Display name**: Watch file movement
- **Category**: Other Utilities
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in asynchronously monitors a specified file location and detects when the file is moved by periodically checking its existence.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `file_name` | string |  | `File_name` |
| `polling_frequency` | integer | `10` (code) | `Polling_frequency` |

### Inputs

- `File_name` (`string`, required)
- `Polling_frequency` (`int`, optional)

### Outputs

- `File_Name` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## WatsonLanguageTranslator

- **Display name**: Watson Language Translator
- **Category**: Integration
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to translate from one language to another using IBM Watson Language Translator service.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `url` | string | `https://gateway.watsonplatform.net/language-translator/api` (code) | `Url` |
| `username` | string |  | `Username` |
| `password` | string |  | `Password` |
| `api_key` | string |  | `Api_key` |
| `api_version` | string | `2018-05-01` (code) | `Api_version` |
| `use_api_key` | boolean | `true` |  |
| `source_language` | string |  | `Source_language` |
| `target_language` | string |  | `Target_language` |
| `input_text` | text |  | `Input_text` |
| `model_id` | string |  | `Model_id` |
| `file_path` | string |  | `File_path` |
| `filename` | string |  | `Filename` |
| `document_id` | string |  | `Document_id` |
| `accept` | string |  | `Accept` |

### Inputs

- `Username` (`string`, required)
- `Password` (`string`, required)
- `Url` (`string`, optional)
- `Api_version` (`string`, optional)
- `Api_key` (`string`, required)
- `Input_text` (`string`, required)
- `Source_language` (`string`, required)
- `Target_language` (`string`, required)
- `Model_id` (`string`, required)
- `File_path` (`string`, required)
- `Filename` (`string`, required)
- `Document_id` (`string`, required)
- `Accept` (`string`, required)

### Outputs

- `Error_Message` (`string`)
- `Result` (`hash` or `string`)
- `Translations` (`array`)
- `Document_id` (`string`)
- `Filename` (`string`)
- `Status` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## WatsonSpeechToText

- **Display name**: Watson speech to text
- **Category**: Quality Control
- **Version**: 0.2.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to get speech transcriptions with IBM Watson Speech to Text service.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `file_path` | string |  |  |
| `url` | string |  |  |
| `username` | string |  |  |
| `password` | string |  |  |
| `model` | string | `en-US_BroadbandModel` (code) |  |
| `keywords` | text |  |  |
| `keywords_threshold` | string | `0.5` (code) |  |
| `polling_frequency` | integer | `10` (code) |  |
| `use_api_key` | boolean |  |  |
| `api_key` | string |  |  |

### Inputs

- None found in source.

### Outputs

- `results` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## WatsonTextToSpeech

- **Display name**: Watson text to speech
- **Category**: Quality Control
- **Version**: 0.2.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides the ability to get speech-synthesis with IBM Watson Text to Speech service.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `file_path` | string |  |  |
| `url` | string |  |  |
| `username` | string |  |  |
| `password` | string |  |  |
| `voice` | string | `en-US_AllisonVoice` (code) |  |
| `text` | text | `Hello! I'm Allison.` (code) |  |
| `use_api_key` | boolean |  |  |
| `api_key` | string |  |  |

### Inputs

- None found in source.

### Outputs

- `file_size` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## WatsonVideoEnrichment

- **Display name**: Watson video enrichment
- **Category**: Quality Control
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This action plug-in provides the ability to get structured information from video files with IBM Watson Video Enrichment service.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `video_url` | text |  |  |
| `api_key` | string |  |  |
| `job_name` | string |  |  |
| `language` | string |  |  |
| `caption_url` | text |  |  |
| `service_url` | string | `https://api-ams.watsonmedia.ibm.com/video-enrichment/v2` (code) |  |
| `return_profanity_analysis_result` | boolean |  |  |
| `save_transcript_result` | boolean |  |  |
| `transcript_result_file_path` | string |  |  |
| `return_video_analysis_result` | boolean |  |  |
| `polling_frequency` | integer | `10` (code) |  |

### Inputs

- None found in source.

### Outputs

- `profanity-analysis_url` (`string`)
- `transcript_url` (`string`)
- `video-analysis_url` (`string`)
- `profanity-analysis` (`hash`)
- `transcript_file_size` (`int`)
- `video-analysis` (`hash`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## WebdavTransfer

- **Display name**: WebDAV Operation
- **Category**: File Transfer
- **Version**: 0.3.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action provides the ability to upload, download, post commands, make directory, gather properties, copy, move, delete or check files on a remote host which supports WedDAV protocol (extended version of he HTTP protocol)

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `operation` | string |  |  |
| `remote_node` | string |  |  |
| `remote_address` | string |  |  |
| `remote_port` | string |  | `Remote_port` |
| `remote_user` | string |  | `Remote_user` |
| `remote_password` | string |  | `Remote_password` |
| `remote_key_location` | string |  |  |
| `source_path` | string |  | `Source_path` |
| `target_path` | string |  | `Target_path` |
| `post_params` | string |  |  |
| `remove_source_file` | boolean | `false` (code) |  |
| `secure_connection` | boolean |  |  |
| `reporting_increment` | integer | `5` (code) |  |
| `user_agent` | string |  |  |
| `verify_ssl` | boolean |  |  |

### Inputs

- `Remote_user` (`string`, optional)
- `Remote_password` (`string`, optional)
- `Remote_port` (`string`, optional)
- `Source_path` (`string`, required)
- `Target_path` (`string`, required)
- `Transferred_files` (`array`)
- `CreationDate:Status:LastModified:DisplayName:LinkToAccess:Type:Size` (`array`)
- `Response_Code` (`int`)
- `Transferred_bytes` (`int`)
- `Remote_node_or_address` (`string`)

### Outputs

- `Transferred_files` (`array`)
- `CreationDate:Status:LastModified:DisplayName:LinkToAccess:Type:Size` (`array`)
- `Response_Code` (`int`)
- `Transferred_bytes` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## WorkOrderMetaData

- **Display name**: Work Order Metadata
- **Category**: System
- **Version**: 0.7.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in provides work order information and enables customization of work order labels and tags. It supports dynamic labeling, tag management, master ID override, and recursive label updates for better work order identification and management.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `label` | string | `` (code) | `Work Order Label` |
| `tags` | string | `[]` (code) | `tags` |
| `strict_label_and_tags` | boolean | `false` |  |
| `show_work_order_id` | boolean | `false` |  |
| `master_id` | string |  | `Master_id` |
| `change_lable_of_master` | boolean | `false` |  |
| `append_tags` | boolean | `true` | `Append_tags` |

### Inputs

- `Work Order Label` (`string`, optional)
- `tags` (`string` or `array`, optional)
- `Append_tags` (`flag`, required)
- `Master_id` (`string` or `int`, optional)

### Outputs

- `Work Order Label Name` (`string`)
- `work_order_id` (`int`)
- `tags` (`array`)
- `master_id` (`int`)
- `previous work step` (`array`)
- `number_of_work_steps_present` (`int`)
- `step_info` (`hash`)
- `longest_steps` (`array`)
- `shortest_steps` (`array`)
- `work_order_url` (`string`)
- `previous_work_step_information` (`array`)
- `initiated_by` (`int`)
- `workflow_name` (`string`)
- `workflow_id` (`int`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## WorkflowLauncher

- **Display name**: Workflow launcher
- **Category**: System
- **Version**: 1.6.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in is used to launch one workflow from within another. It is similar to, but not the same as, the SubWorkflow plug-in. The main difference is that WorkflowLauncher launches another workflow and then immediately allows the current workflow to proceed. This behavior is asynchronous, whereas in SubWorkflow, the current workflow waits for the launched workflow to complete before continuing. A WorkflowLauncher step is considered Complete once it has successfully launched the configured workflow, while a SubWorkflow step is considered Complete only after the sub-workflow it launched has finished execution.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `workflow_id` | integer |  |  |
| `comments` | text |  |  |
| `priority` | integer | `WorkOrder::DEFAULT_PRIORITY rescue 2` (code) |  |
| `saved_inputs` | text |  |  |
| `work_order_name` | string |  | `WorkOrder_Description` |
| `use_true_name` | boolean |  |  |
| `running_as_user` | string |  | `Running_as_user` |
| `tags` | text |  | `Tags` |
| `launched_comments` | text |  | `Launched_comments` |
| `wait_for_completion` | boolean | `false` (code) |  |
| `polling_frequency` | integer | `1` (code) |  |
| `master_id` | text |  |  |
| `fail_if_failure` | boolean | `false` (code) |  |
| `use_portable_id` | boolean | `false` |  |
| `portable_id` | string |  | `Workflow_Portable_Id` |
| `workflow_inputs` | text |  |  |
| `dedicated_worker` | boolean |  |  |

### Inputs

- `Tags` (`string` or `array`, optional)
- `Workflow_Portable_Id` (`string`, required)
- `WorkOrder_Description` (`string`, optional)
- `Running_as_user` (`string`, optional)
- `Launched_comments` (`string`, optional)
- `WorkOrder_ID` (`int`)
- `WorkOrder_Status` (`string`)
- `Master_id` (`int`)
- `Workflow_ID` (`int`)
- `Workflow_Parameters` (`hash`)
- `Execution_priority` (`int`)

### Outputs

- `WorkOrder_ID` (`int`)
- `WorkOrder_Status` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## XfConverter

- **Display name**: Xf converter
- **Category**: Transcoding
- **Version**: 0.3.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plug-in provides the ability to convert (rewrap) audio and video wrapper files (AVI, GXF, MOV, MP4 and MXF) with OpenCube XFConverter. It implements the XFConverter SOAP based WEB service API 2.0

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `remote_node` | string |  |  |
| `server_address` | string |  |  |
| `server_port` | integer | `1111` (code) |  |
| `polling_frequency` | integer | `10` (code) |  |
| `profile` | string |  | `profile` |
| `source` | string |  | `source` |
| `destination` | string |  | `destination` |
| `init_from_type` | string |  |  |
| `overwrite_flag` | boolean |  |  |

### Inputs

- `profile` (`string`, required)
- `source` (`string`, required)
- `destination` (`string`, required)
- `XML_result` (`string`)
- `Xf_status_message` (`string`)
- `remote node or server address` (`string`)

### Outputs

- `XML_result` (`string`)
- `Xf_status_message` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## XmlParsing

- **Display name**: Xml Parsing
- **Category**: Other Utilities
- **Version**: 0.1.3 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in extracts data from XML documents using XPath expressions. It supports XML input from text strings or file paths, allowing multiple configurable parameters to be exposed as workflow outputs.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `parameters` | text |  | `Parameters` |
| `accept_xml_as_string` | boolean |  | `Accept_xml_as` |
| `xml_file_as_string` | text |  |  |
| `xml_file_path` | text |  |  |

### Inputs

- `Parameters` (`string`, required)
- `Accept_xml_as` (`string`, required)
- `xml_file_as_string` (`string`)
- `xml_file_path` (`string`)

### Outputs

- None found in source.
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.
- Outputs are partly defined by template fields: see the template attributes.

## XsdValidation

- **Display name**: XSD Validation
- **Category**: Quality Control
- **Version**: 0.2.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in is used to validate an XML file against an XSD template.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `xml_body` | text |  | `XML_content_or_path` |
| `xml_file_path` | string |  | `VAR_XML_BODY` |
| `xsd_body` | text |  | `XSD_content_or_path` |
| `xsd_file_path` | string |  | `VAR_XSD_BODY` |
| `validation_command` | text | `xmllint --noout --schema <%= xsd_filepath %> <%= xml_filepath %> 2> <%= error_report_filepath %>` (code) |  |
| `multiple_xsd` | boolean |  |  |
| `xsd_paths` | text |  |  |

### Inputs

- `XML_content_or_path` (`string`, required)
- `VAR_XML_BODY` (`string`, required)
- `XSD_content_or_path` (`string`, required)
- `VAR_XSD_BODY` (`string`, required)
- `XSD_paths` (`array`)

### Outputs

- `Validation_errors` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.

## XsltTransformation

- **Display name**: XSLT Transformation
- **Category**: File Transformations
- **Version**: 0.1.1 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plug-in is used to transform XML file using XSLT.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `xml_body` | text |  | `XML_content_or_path` |
| `xml_file_path` | string |  | `VAR_XML_BODY` |
| `xslt_body` | text |  | `XSLT_content_or_path` |
| `xslt_file_path` | string |  | `VAR_XSLT_BODY` |
| `target_file_path` | string |  | `Target_file_path` |
| `return_file_as_output` | boolean |  |  |

### Inputs

- `Target_file_path` (`string`, optional)
- `XML_content_or_path` (`string`, required)
- `VAR_XML_BODY` (`string`, required)
- `XSLT_content_or_path` (`string`, required)
- `VAR_XSLT_BODY` (`string`, required)

### Outputs

- `Generated_file_path` (`string`)
- `Generated_file_content` (`string`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Method `outputs_spec` has conditions: some outputs exist only for some template settings.

## XytechMediaPulse

- **Display name**: XytechMediaPulse
- **Category**: Asset Management
- **Version**: 0.1.0 (requires Orchestrator 4.1.0 or later)
- **Description**: This plug-in provides the ability to query the MediaPulse API and return MediaOrders and corresponding source file(s).

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | string |  |  |
| `endpoint` | string |  | `Endpoint` |
| `payload_file` | string |  | `Payload_file` |
| `payload` | text |  |  |
| `polling_frequency` | integer |  |  |
| `max_records` | integer |  |  |
| `keep_ongoing` | boolean |  |  |
| `polling_stop_condition` | text |  |  |
| `result_type` | string |  |  |
| `saved_inputs` | text |  |  |

### Inputs

- `Endpoint` (`string`, required)
- `Payload_file` (`string`, required)

### Outputs

- `Status` (`string`)
- `Row_count` (`string`)
- `Response_message` (`string`)
- `Response_code` (`string`)
- `MO_list` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.

## ZencoderTranscoding

- **Display name**: Zencoder transcoding
- **Category**: Transcoding
- **Version**: 0.3.2 (requires Orchestrator 4.1.6 or later)
- **Description**: This action plugin provides the ability to submit file transformation jobs to the Zencoder cloud service.

### Template attributes

| Attribute | Type | Default | Input if blank |
|-----------|------|---------|----------------|
| `name` | string |  |  |
| `comments` | text |  |  |
| `input_uri` | string |  |  |
| `outputs_payload` | text | `[{ label: 'Default transformation', url: "<%=` (code) |  |
| `saved_inputs` | text |  |  |
| `api_key` | string |  |  |
| `status_polling_frequency` | integer | `5` (code) |  |
| `output_spec_file` | string |  |  |
| `region` | string |  |  |

### Inputs

- None found in source.

### Outputs

- `Output URIs` (`array`)
- `Step_information` (`hash`)

### Notes

- Method `inputs_spec` has conditions: some inputs exist only for some template settings.
- Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.
