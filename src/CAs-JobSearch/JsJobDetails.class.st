Class {
	#name : #JsJobDetails,
	#superclass : #WAComponent,
	#instVars : [
		'job'
	],
	#category : #'CAs-JobSearch'
}

{ #category : #accessing }
JsJobDetails >> job:aJob [
job:=aJob
]

{ #category : #rendering }
JsJobDetails >> renderContentOn: html [

	html heading
		level1;
		with: 'Jobbdetaljer'.
	html text: job webpage_url.
	html break.
	html heading
		level2;
		with: [ 
			html anchor
			url:job webpage_url ;
				with: job headline ].
	html div with: [ html html: job descriptionHtml ].
	html horizontalRule.
	self renderPropertiesOn: html.
	html horizontalRule.
	html anchor
		callback: [ self answer ];
		with: 'Stäng'
]

{ #category : #rendering }
JsJobDetails >> renderPropertiesOn: html [

	html table: [ 
		html tableRow: [ 
			html tableHeading: 'Occupation'.
			html tableData: job occupation.
			html tableData: [ 
				html anchor
					callback: [ self filterOccupation ];
					with: 'Lägg till i filter' ] ].
		html tableRow: [ 
			html tableHeading: 'Occupation Group'.
			html tableData: job occupationGroup.
			html tableData: [ 
				html anchor
					callback: [ self filterOccupationGroup ];
					with: 'Lägg till i filter' ] ].
		html tableRow: [ 
			html tableHeading: 'Occupation Field'.
			html tableData: job occupationField.
			html tableData: [ 
				html anchor
					callback: [ self filterOccupationField ];
					with: 'Lägg till i filter' ] ] ]
]
