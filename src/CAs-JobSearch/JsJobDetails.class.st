Class {
	#name : #JsJobDetails,
	#superclass : #WAComponent,
	#instVars : [
		'job'
	],
	#category : #'CAs-JobSearch'
}

{ #category : #rendering }
JsJobDetails >> filterOccupation [

	JsJobHub default addFilterOccupation: job occupation
]

{ #category : #rendering }
JsJobDetails >> filterOccupationField [

	JsJobHub default addFilterField: job occupationField
]

{ #category : #rendering }
JsJobDetails >> filterOccupationGroup [

JsJobHub default addFilterGroup: job occupationGroup
]

{ #category : #accessing }
JsJobDetails >> job:aJob [
job:=aJob
]

{ #category : #rendering }
JsJobDetails >> renderContentOn: html [

	html heading
		level1;
		with: [ 
			html anchor
				url: job webpage_url;
				with: job headline ].
			html anchor
							callback: [ JsJobHub default addFilterJob: job ];
							with: '  (Dölj detta jobb)'.
	html image url: job logo_url.
	html break.
	"html text: job webpage_url."
	html break.

	html div
		style: 'width:600px';
		with: [ html html: job descriptionHtml ].
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
