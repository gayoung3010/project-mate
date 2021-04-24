/**
 * @license Copyright (c) 2003-2020, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see https://ckeditor.com/legal/ckeditor-oss-license
 */

CKEDITOR.editorConfig = function( config ) {
	config.toolbar = 'Full'; 
	config.toolbar = 'MyToolbar'; 
	config.toolbar_Full = [ ['Source','-','Save','NewPage','Preview','-','Templates'], ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'], ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'], ['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'], ['BidiLtr', 'BidiRtl'], '/', ['Bold','Italic','Underline','Strike','-','Subscript','Superscript'], ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'], ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'], ['Link','Unlink','Anchor'], ['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak'], '/', ['Styles','Format','Font','FontSize'], ['TextColor','BGColor'], ['Maximize', 'ShowBlocks','-','About'] ]; 
	config.toolbar_Basic = [ ['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink','-','About'] ];
	config.toolbar_MyToolbar = 
		[ 
			['Cut','Copy','Paste','PasteText','PasteFromWord','-','Scayt'], 
			['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
			['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar'], 
			'/', 
			['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
			'/', 
			['Styles','Format','Font','FontSize','Bold','Italic','Strike'], 
			['Link','Unlink','Maximize']

		];


};
