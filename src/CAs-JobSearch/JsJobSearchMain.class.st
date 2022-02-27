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

{ #category : #rendering }
JsJobSearchMain >> fields [

	| tmp |
	tmp := OrderedCollection with: 'Alla'.
	tmp addAll: (self jobs collect: #occupationField) asSet sorted.
	^ tmp
]

{ #category : #rendering }
JsJobSearchMain >> filterView [

	viewJobs := self jobs
]

{ #category : #rendering }
JsJobSearchMain >> getJobs [

	JsJobHub default getJobs
]

{ #category : #rendering }
JsJobSearchMain >> groups [

	| tmp |
	tmp := OrderedCollection with: 'Alla'.
	tmp addAll: (self jobs collect: #occupationGroup) asSet sorted.^tmp
]

{ #category : #initialization }
JsJobSearchMain >> initialize [

	super initialize.viewFilter:=Dictionary new.
]

{ #category : #rendering }
JsJobSearchMain >> jobs [ ^JsJobHub default jobs
]

{ #category : #rendering }
JsJobSearchMain >> occupations [

	| tmp |
	tmp := OrderedCollection with: 'Alla'.
	tmp addAll: (self jobs collect: #occupation) asSet sorted.
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

	self jobs do: [ :each | 
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
							callback: [ JsJobHub default addFilterJob: each ];
							with: '  (Dölj detta jobb)' ].

				html anchor
					callback: [ 
						JsJobHub default addFilterOccupation: each occupation ];
					with: each occupation.
				html text: ' * '.

				html anchor
					callback: [ 
						JsJobHub default addFilterGroup: each occupationGroup ];
					with: each occupationGroup.
				html text: ' * '.
				html anchor
					callback: [ 
						JsJobHub default addFilterField: each occupationField ];
					with: each occupationField ] ]
]

{ #category : #rendering }
JsJobSearchMain >> renderViewFilterOn: html [

	html text: 'Field: '.
	html select
		list: self fields;
		selected: (viewFilter at: #field ifAbsent: [ 'Alla' ]);
		callback: [ :value | 
			value = #Male
				ifTrue: [ self contact beMale ]
				ifFalse: [ self contact beFemale ] ].
	html text: 'Group: '.
	html select
		list: self groups;
		selected: (viewFilter at: #group ifAbsent: [ 'Alla' ]);
		callback: [ :value | 
			value = #Male
				ifTrue: [ self contact beMale ]
				ifFalse: [ self contact beFemale ] ].
	html text: 'Occupation: '.
	html select
		list: self occupations;
		selected: (viewFilter at: #occupation ifAbsent: [ 'Alla' ]);
		callback: [ :value | 
			value = #Male
				ifTrue: [ self contact beMale ]
				ifFalse: [ self contact beFemale ] ]
]

{ #category : #rendering }
JsJobSearchMain >> retrievalTime [

	^ JsJobHub default retrievalTime
		  ifNil: [ 'Vet inte' ]
		  ifNotNil: [ :val | val asStringYMDHM ]
]

{ #category : #rendering }
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
