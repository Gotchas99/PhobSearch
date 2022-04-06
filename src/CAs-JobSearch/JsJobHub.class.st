Class {
	#name : #JsJobHub,
	#superclass : #Object,
	#instVars : [
		'connection',
		'rawJobs',
		'jobs',
		'filter',
		'retrievalTime'
	],
	#classVars : [
		'Default'
	],
	#category : #'CAs-JobSearch'
}

{ #category : #accessing }
JsJobHub class >> default [

	^ Default ifNil: [Default := self new ]
]

{ #category : #'class initialization' }
JsJobHub class >> initialize [

	SessionManager default registerUserClassNamed: self name
]

{ #category : #accessing }
JsJobHub class >> reset [

	<script>
Default:=nil
]

{ #category : #'class initialization' }
JsJobHub class >> shutDown: quitting [

	self default closeDb
]

{ #category : #'class initialization' }
JsJobHub class >> startUp: resuming [

	resuming ifTrue: [ self default readFile ].
	self default openDb.
]

{ #category : #action }
JsJobHub >> addFilterField: aString [

(	filter at: #filterField) add: aString.
	self filterJobs
]

{ #category : #action }
JsJobHub >> addFilterGroup: aString [

(	filter at: #filterGroup) add: aString.
	self filterJobs
]

{ #category : #action }
JsJobHub >> addFilterJob: aJobFull [

	| jobShort |
	jobShort := Dictionary new at: #id put: (aJobFull id);at:#headline put:(aJobFull headline);yourself.
	self filterSingleJobs add: jobShort.
	self filterJobs
]

{ #category : #action }
JsJobHub >> addFilterOccupation: aString [

	(filter at: #filterOccupation) add: aString.
	self filterJobs
]

{ #category : #database }
JsJobHub >> closeDb [

	connection ifNotNil:[connection close]
]

{ #category : #accessing }
JsJobHub >> filterField [

	^( filter at: #filterField ifAbsentPut: [ Set new ])sorted
]

{ #category : #accessing }
JsJobHub >> filterGroup [

	^ (filter at: #filterGroup ifAbsentPut: [ Set new ]) sorted
]

{ #category : #action }
JsJobHub >> filterJobs [

	| tmp |
	self writeFile.
	tmp := rawJobs.
	self filterSingleJobs do: [ :each | 
		tmp := tmp reject: [ :job | job id = (each at:#id)] ].
	self filterField do: [ :each | 
		tmp := tmp reject: [ :job | job occupationField = each ] ].
	self filterGroup do: [ :each | 
		tmp := tmp reject: [ :job | job occupationGroup = each ] ].
	self filterOccupation do: [ :each | 
		tmp := tmp reject: [ :job | job occupation = each ] ].
	^ jobs := tmp
]

{ #category : #accessing }
JsJobHub >> filterOccupation [

	^ (filter at: #filterOccupation ifAbsentPut: [ Set new ])sorted
]

{ #category : #accessing }
JsJobHub >> filterSingleJobs [

	^ (filter at: #filterSingleJobs ifAbsentPut: [ Set new ])
]

{ #category : #action }
JsJobHub >> getJobs [

	| api |
	api := JsApi new.
	rawJobs := api search.
	retrievalTime := DateAndTime current.
	self traceCr: 'Retrieving jobs at: ',retrievalTime asString.
	self filterJobs
]

{ #category : #initialization }
JsJobHub >> initialize [

	super initialize.
	jobs := #(  ).rawJobs  := #(  ).
	filter := Dictionary new
]

{ #category : #accessing }
JsJobHub >> jobId: anId [

	^ rawJobs  detect: [ :job | job id = anId ]
]

{ #category : #accessing }
JsJobHub >> jobs [

^jobs
]

{ #category : #database }
JsJobHub >> openDb [

	connection := SQLite3Connection on:
		              (Smalltalk imageDirectory / 'PhobDatabase.db')
			              fullName.connection open.
]

{ #category : #file }
JsJobHub >> readFile [

	^ filter := self savefile ifExists: [:f|f readStreamDo: [ :stream | 
		            STON fromStream: stream ]]
]

{ #category : #action }
JsJobHub >> removeFilterField: aString [

self 	filterField remove: aString.
	self filterJobs
]

{ #category : #action }
JsJobHub >> removeFilterGroup: aString [

self 	filterGroup remove: aString.
	self filterJobs
]

{ #category : #action }
JsJobHub >> removeFilterJob: aJobShort [

	self filterSingleJobs  remove: aJobShort ifAbsent:[].
	self filterJobs
]

{ #category : #action }
JsJobHub >> removeFilterOccupation: aString [

	self filterOccupation remove: aString.
	self filterJobs
]

{ #category : #accessing }
JsJobHub >> retrievalTime [
^retrievalTime
]

{ #category : #file }
JsJobHub >> savefile [

	^ 'saved_JsJobHub.ston' asFileReference
]

{ #category : #file }
JsJobHub >> writeFile [

	self savefile ensureDelete writeStreamDo: [ :stream | 
		STON put: filter onStreamPretty: stream ]
]
