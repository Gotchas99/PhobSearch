Class {
	#name : #JsJobSearchMain,
	#superclass : #WAComponent,
	#instVars : [
		'rawJobs',
		'jobs',
		'filterOccupation',
		'filterGroup',
		'filterField'
	],
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
JsJobSearchMain >> addFilterField: aString [

	filterField add: aString
]

{ #category : #rendering }
JsJobSearchMain >> addFilterGroup: aString [

	filterGroup add: aString
]

{ #category : #rendering }
JsJobSearchMain >> addFilterOccupation:aString [
filterOccupation add:aString
]

{ #category : #rendering }
JsJobSearchMain >> filterJobs [

	| tmp |
	tmp := rawJobs.
	filterGroup do: [ :grp | 
		tmp := tmp reject: [ :job | job occupationGroup = grp ] ].
	^ tmp
]

{ #category : #rendering }
JsJobSearchMain >> filterJobs: aRawJobs [

	| tmp |
	tmp := aRawJobs.
	filterGroup do: [ :grp | tmp:=tmp reject:[:job|job occupationGroup=grp] ].
	^ tmp
]

{ #category : #rendering }
JsJobSearchMain >> getJobs [

	| api |
	api := JsApi new.
	rawJobs := api get.
	jobs := self filterJobs
]

{ #category : #initialization }
JsJobSearchMain >> initialize [

	super initialize.
	jobs := #(  ).
	filterOccupation := OrderedCollection new.
	filterGroup := OrderedCollection with: 'Personliga assistenter'.
	filterField:= OrderedCollection new.
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
	filterOccupation  do: [ :each | 
		html div with: [ 
			html text: each.
			html break ] ].
	html heading
		level4;
		with: 'Occupation group'.
	filterGroup do: [ :each | 
		html div with: [ 
			html text: each.
			html break ] ].
	html heading
		level4;
		with: 'Occupation Field'.
	filterField do: [ :each | 
		html div with: [ 
			html text: each.
			html break ] ]
]

{ #category : #rendering }
JsJobSearchMain >> renderJobsOn: html [

	jobs do: [ :each | 
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
