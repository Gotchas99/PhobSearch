Class {
	#name : #JsJobSearchMain,
	#superclass : #WAComponent,
	#instVars : [
		'viewFilter',
		'viewJobs'
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

{ #category : #accessing }
JsJobSearchMain >> fields [

	| tmp |
	tmp := OrderedCollection with: 'Alla'.
	tmp addAll: (self jobs collect: #occupationField) asSet sorted.
	^ tmp
]

{ #category : #filtering }
JsJobSearchMain >> filter [

	self filterView
]

{ #category : #filtering }
JsJobSearchMain >> filterView [

	viewJobs := self jobs.
	(viewFilter at: #field) = 'Alla' ifFalse: [ 
		viewJobs := viewJobs select: [ :job | 
			            job occupationField = (viewFilter at: #field) ] ].
	(viewFilter at: #group) = 'Alla' ifFalse: [ 
		viewJobs := viewJobs select: [ :job | 
			            job occupationGroup = (viewFilter at: #group) ] ].
	(viewFilter at: #occupation) = 'Alla' ifFalse: [ 
		viewJobs := viewJobs select: [ :job | 
			            job occupation = (viewFilter at: #occupation) ] ]
]

{ #category : #accessing }
JsJobSearchMain >> getJobs [

	JsJobHub default getJobs.self filterView
]

{ #category : #accessing }
JsJobSearchMain >> groups [

	| tmp j|
	j:=self jobs.
((	viewFilter at:'field')='Alla')ifFalse:[j:= j select:[:aJob|aJob occupationField =(	viewFilter at:'field')]].
	tmp := OrderedCollection with: 'Alla'.
	tmp addAll: (j collect: #occupationGroup) asSet sorted.
	^ tmp
]

{ #category : #initialization }
JsJobSearchMain >> initialize [

	super initialize.
	self filterView.
	viewFilter := Dictionary new
		              at: #field put: 'Alla';
		              at: #group put: 'Alla';
		              at: #occupation put: 'Alla';
		              yourself
]

{ #category : #accessing }
JsJobSearchMain >> jobs [ ^JsJobHub default jobs
]

{ #category : #accessing }
JsJobSearchMain >> occupations [

	| tmp j |
	j := self jobs.
	(viewFilter at: 'group') = 'Alla' ifFalse: [ 
		j := j select: [ :aJob | 
			     aJob occupationGroup = (viewFilter at: 'group') ] ].
	tmp := OrderedCollection with: 'Alla'.
	tmp addAll: (j collect: #occupation) asSet sorted.
	^ tmp
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
	html text: 'Antal jobb ' , self jobs size asString.
	html break.
	html text: 'Senast hämtade: ' , self retrievalTime.
	html break.html break.
	self renderViewFilterOn: html.
	html break.
	self renderJobsOn: html.
	html horizontalRule.
	self renderFilter: html
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

{ #category : #rendering }
JsJobSearchMain >> renderJobsOn: html [

	viewJobs do: [ :each | 
		html div
			class: #fooRow;
			with: [ 
				html heading
					level3;
					with: [ 
						html anchor
							callback: [ self showJob: each ];
							with: each headline.
						html text: ' (' , each employer , ') '.
						html anchor
							callback: [ 
								JsJobHub default addFilterJob: each.
								self filterView ];
							with: '  (Dölj detta jobb)' ].

				html anchor
					callback: [ 
						JsJobHub default addFilterOccupation: each occupation .
								self filterView];
					with: each occupation.
				html text: ' * '.

				html anchor
					callback: [ 
						JsJobHub default addFilterGroup: each occupationGroup .
								self filterView];
					with: each occupationGroup.
				html text: ' * '.
				html anchor
					callback: [ 
						JsJobHub default addFilterField: each occupationField.
								self filterView ];
					with: each occupationField ] ]
]

{ #category : #rendering }
JsJobSearchMain >> renderViewFilterOn: html [

	html form: [ 
		html text: 'Field: '.
		html select
			list: self fields;
			selected: (viewFilter at: #field ifAbsent: [ 'Alla' ]);
			callback: [ :value | self setField: value ].
		html text: 'Group: '.
		html select
			list: self groups;
			selected: (viewFilter at: #group ifAbsent: [ 'Alla' ]);
			callback: [ :value | self setGroup: value ].
		html text: 'Occupation: '.
		html select
			list: self occupations;
			selected: (viewFilter at: #occupation ifAbsent: [ 'Alla' ]);
			callback: [ :value | self setOccupation: value ].
		html submitButton on: #filter of: self ]
]

{ #category : #accessing }
JsJobSearchMain >> retrievalTime [

	^ JsJobHub default retrievalTime
		  ifNil: [ 'Vet inte' ]
		  ifNotNil: [ :val | val asStringYMDHM ]
]

{ #category : #filtering }
JsJobSearchMain >> setField: value [

	viewFilter at: #field put:value
]

{ #category : #filtering }
JsJobSearchMain >> setGroup: value [

	viewFilter at: #group put: value
]

{ #category : #filtering }
JsJobSearchMain >> setOccupation: value [


	viewFilter at: #occupation put: value
]

{ #category : #accessing }
JsJobSearchMain >> showJob: aJob [


    self call: (JsJobDetails  new 
        job: aJob;
        yourself)
]

{ #category : #hooks }
JsJobSearchMain >> style [
    ^ 'h1 { text-align: center; }'
]

{ #category : #updating }
JsJobSearchMain >> updateRoot: anHtmlRoot [

	super updateRoot: anHtmlRoot.
	anHtmlRoot title: 'PhobSearch'
]
