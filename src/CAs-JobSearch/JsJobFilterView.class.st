Class {
	#name : #JsJobFilterView,
	#superclass : #WAComponent,
	#category : #'CAs-JobSearch-Web'
}

{ #category : #rendering }
JsJobFilterView >> renderContentOn: html [

	html heading
		level1;
		with: 'Phob search - Filter'.
		html anchor
		callback: [ 
		
			self answer ];
		with: '  Stäng filter'.
	self renderFilter: html
]

{ #category : #rendering }
JsJobFilterView >> renderFilter: html [
	html heading
		level3;
		with: 'Dessa tas med'.
	html heading
		level4;
		with: 'Göteborg, tills vidare, deltid (inga procent längre)'.
	html heading
		level3;
		with: 'Nedanstående tas bort'.
	html heading
		level4;
		with: 'Occupation'.
	JsJobHub default filterOccupation do: [ :each | 
		html div with: [ 
			html anchor
				callback: [ JsJobHub default removeFilterOccupation: each ];
				with: each ] ].
	html heading
		level4;
		with: 'Occupation group'.
	JsJobHub default filterGroup do: [ :each | 
		html div with: [ 
			html anchor
				callback: [ JsJobHub default removeFilterGroup: each ];
				with: each ] ].
	html heading
		level4;
		with: 'Occupation Field'.
	JsJobHub default filterField do: [ :each | 
		html div with: [ 
			html anchor
				callback: [ JsJobHub default removeFilterField: each ];
				with: each ] ].
	html heading
		level4;
		with: 'Enskilda jobb'.
	JsJobHub default filterSingleJobs do: [ :each | 
		html div with: [ 
			html anchor
				callback: [ JsJobHub default removeFilterJob: each ];
				with: (each at: #headline) ] ]
]
