# -*- mode: yaml -*-
# vi: set ft=yaml :
libraries:
  ckeditor:
    download:
      type: file
      url: "http://download.cksource.com/CKEditor/CKEditor/CKEditor%204.5.10/ckeditor_4.5.10_full.zip"
  iframedialog:
    subdir: ckeditor/plugins
    download:
      type: file
      url: "http://download.ckeditor.com/iframedialog/releases/iframedialog_4.5.10.zip"
  plupload:
    download:
      type: file
      url: "https://github.com/moxiecode/plupload/archive/v1.5.8.zip"
  PHPExcel:
    download:
      type: file
      url: "https://github.com/PHPOffice/PHPExcel/archive/1.8.zip"
  chosen:
    download:
      type: file
      url: "https://github.com/harvesthq/chosen/releases/download/1.4.2/chosen_v1.4.2.zip"
  tcpdf:
    download:
      type: file
      url: "http://downloads.sourceforge.net/project/tcpdf/tcpdf_6_2_13.zip"
  html_encode:
    download:
      type: file
      url: "https://www.strictly-software.com/scripts/downloads/encoder.js"
  jquery.blockui:
    download:
      type: file
      url: "https://raw.githubusercontent.com/malsup/blockui/2.70/jquery.blockUI.js"
      filename: "jquery.blockui.js"
  flexslider:
    download:
      type: file
      url: "https://github.com/woothemes/FlexSlider/archive/version/2.5.0.tar.gz"
projects:
  addthis:
    type: module
    subdir: contrib
    version: "4.0-alpha6"
  admin_menu:
    type: module
    subdir: contrib
    version: "3.0-rc5"
  admin_views:
    type: module
    subdir: contrib
    version: "1.5"
  backup_migrate:
    type: module
    subdir: contrib
    version: "2.8"
  block_class:
    type: module
    subdir: contrib
    version: "2.3"
  ckeditor:
    type: module
    subdir: contrib
    version: "1.17"
  colorbox:
    type: module
    subdir: contrib
    version: "2.12"
  ctools:
    type: module
    subdir: contrib
    version: "1.9"
  diff:
    type: module
    subdir: contrib
    version: "3.2"
  dragndrop_upload:
    type: module
    subdir: contrib
    version: "1.0-alpha2"
  entity:
    type: module
    subdir: contrib
    version: "1.7"
  entitycache:
    type: module
    subdir: contrib
    version: "1.5"
  eva:
    type: module
    subdir: contrib
    version: "1.2"
  features:
    type: module
    subdir: contrib
    version: "2.10"
  features_diff:
    type: module
    subdir: contrib
    version: "1.0-beta2"
  features_extra:
    type: module
    subdir: contrib
    version: "1.0"
  feeds:
    type: module
    subdir: contrib
    version: "2.0-beta2"
  feeds_xls:
    type: module
    subdir: contrib
    version: "1.2"
  field_group:
    type: module
    subdir: contrib
    version: "1.5"
  filefield_sources:
    type: module
    subdir: contrib
    version: "1.10"
  filefield_sources_plupload:
    type: module
    subdir: contrib
    version: "1.1"
  fpa:
    type: module
    subdir: contrib
    version: "2.6"
  google_analytics:
    type: module
    subdir: contrib
    version: "2.2"
  imagemagick:
    type: module
    subdir: contrib
    version: "1.0"
  jcarousel:
    type: module
    subdir: contrib
    version: "2.7"
  job_scheduler:
    type: module
    subdir: contrib
    version: "2.0-alpha3"
  jquery_update:
    type: module
    subdir: contrib
    version: "2.7"
  libraries:
    type: module
    subdir: contrib
    version: "2.3"
  media:
    type: module
    subdir: contrib
    version: "1.5"
  menu_block:
    type: module
    subdir: contrib
    version: "2.7"
  menu_attributes:
    type: module
    subdir: contrib
    version: "1.x-dev"
  menu_block:
    type: module
    subdir: contrib
    version: "2.7"
  metatag:
    type: module
    subdir: contrib
    version: "1.17"
  mobile_navigation:
    type: module
    subdir: contrib
    version: "1.2"
  module_filter:
    type: module
    subdir: contrib
    version: "2.0"
  multiupload_filefield_widget:
    type: module
    subdir: contrib
    version: "1.13"
  node_embed:
    type: module
    subdir: contrib
    version: "1.2"
  nodequeue:
    type: module
    subdir: contrib
    version: "2.0"
  nodequeue_pager:
    type: module
    subdir: contrib
    download:
      type: file
      url: https://github.com/livingstoneonline/nodequeue_pager/archive/7.x-1.x.tar.gz
  panels:
    type: module
    subdir: contrib
    version: "3.5"
  pathauto:
    type: module
    subdir: contrib
    version: "1.3"
  plupload:
    type: module
    subdir: contrib
    version: "1.7"
  print:
    type: module
    subdir: contrib
    version: "1.3"
  private_files_download_permission:
    type: module
    subdir: contrib
    version: "2.5"
  qtip:
    type: module
    subdir: contrib
    version: "2.0-rc4"
  redirect:
    type: module
    subdir: contrib
    version: "1.0-rc3"
  sharethis:
    type: module
    subdir: contrib
    version: "2.13"
  stage_file_proxy:
    type: module
    subdir: contrib
    version: "1.7"
  strongarm:
    type: module
    subdir: contrib
    version: "2.0"
  taxonomy_breadcrumb:
    type: module
    subdir: contrib
    version: "1.x-dev"
  token:
    type: module
    subdir: contrib
    version: "1.6"
  uuid:
    type: module
    subdir: contrib
    version: "1.0-beta1"
  uuid_features:
    type: module
    subdir: contrib
    version: "1.0-alpha4"
  views:
    type: module
    subdir: contrib
    version: "3.14"
  views_bulk_operations:
    type: module
    subdir: contrib
    version: "3.3"
  views_field_view:
    type: module
    subdir: contrib
    version: "1.2"
  views_infinite_scroll:
    type: module
    subdir: contrib
    version: "1.1"
  views_php:
    type: module
    subdir: contrib
    version: "1.0-alpha3"
  xsl_formatter:
    type: module
    subdir: contrib
    version: "1.1"
  flexslider:
    type: module
    subdir: contrib
    version: "2.0-rc1"
  jquerymenu:
    type: module
    subdir: contrib
    version: "4.0-alpha3"
  date:
    type: module
    subdir: contrib
    version: "2.9"
  simple_timeline:
    type: module
    subdir: contrib
    version: "1.0"
  filedepot:
    type: module
    subdir: contrib
    version: "1.3"
  themekey:
    type: module
    subdir: contrib
    version: 3.4
