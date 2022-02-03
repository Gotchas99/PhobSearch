Class {
	#name : #JsJobSearchMain,
	#superclass : #WAComponent,
	#category : #'CAs-JobSearch'
}

{ #category : #testing }
JsJobSearchMain class >> canBeRoot [
    ^true
]

{ #category : #testing }
JsJobSearchMain class >> initialize [


	WAAdmin register: self asApplicationAt: 'phobsearch'
	"    app libraries add: SULibrary.
    app preferenceAt: #sessionClass put: FooSession"
]

{ #category : #rendering }
JsJobSearchMain >> getJobs [

	JsJobHub default getJobs
]

{ #category : #initialization }
JsJobSearchMain >> initialize [

	super initialize.

]

{ #category : #rendering }
JsJobSearchMain >> jobs [ ^JsJobHub default jobs
]

{ #category : #rendering }
JsJobSearchMain >> renderContentOn: html [

	html heading
		level1;
		with: 'Phob search'.
	"	html submitButton on: #getJobs of: self."
	html break.
	html anchor
		callback: [ self getJobs ];
		with: 'Hämta annonser'.
	html break.
	html break.
	self renderJobsOn: html.
	html horizontalRule.
	self renderFilter:html
	"	html form: [ 
		html heading
			level3;
			with: 'User Name:'.
		html textInput on: #userName of: self.
		html heading
			level3;
			with: 'Password:'.
		html passwordInput on: #password of: self.
		html
			break;
			""on: #login of: self""submitButton ]"
]

{ #category : #rendering }
JsJobSearchMain >> renderFilter: html [

	html heading
		level2;
		with: 'Filter'.
	html heading
		level3;
		with: 'Dessa tas med'.
	html heading
		level4;
		with: 'Göteborg, tills vidare, deltid 30-70%'.
	html heading
		level3;
		with: 'Nedanstående tas bort'.
	html heading
		level4;
		with: 'Occupation'.
	JsJobHub default filterOccupation do: [ :each | 
		html div with: [ 
			html text: each.
			html break ] ].
	html heading
		level4;
		with: 'Occupation group'.
	JsJobHub default filterGroup do: [ :each | 
		html div with: [ 
			html text: each.
			html break ] ].
	html heading
		level4;
		with: 'Occupation Field' .JsJobHub default filterField
		do: [ :each | 
			html div with: [ 
					html text: each.
					html break ] ]
]

{ #category : #rendering }
JsJobSearchMain >> renderJobsOn: html [

	self jobs do: [ :each | 
		html div
			class: #fooRow;
			with: [ 
				html heading
					level3;
					with: [ 
						html anchor
							callback: [ self showJob: each ];
							with: each headline ].
				html text:
					'(' , each occupation , ' * ' , each occupationGroup , ' * '
					, each occupationField , ')' ] ]
]

{ #category : #rendering }
JsJobSearchMain >> showJob: aJob [


    self call: (JsJobDetails  new 
        job: aJob;
        yourself)
]
