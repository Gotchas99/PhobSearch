Class {
	#name : #JsJobHub,
	#superclass : #Object,
	#instVars : [
		'rawJobs',
		'jobs',
		'filter',
		'filterOccupation',
		'filterGroup',
		'filterField',
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

{ #category : #accessing }
JsJobHub class >> reset [

	<script>
Default:=nil
]

{ #category : #action }
JsJobHub >> addFilterField: aString [

	self filterField add: aString.
	self filterJobs
]

{ #category : #action }
JsJobHub >> addFilterGroup: aString [

	self filterGroup add: aString.
	self filterJobs
]

{ #category : #action }
JsJobHub >> addFilterOccupation: aString [

self 	filterOccupation add: aString.
	self filterJobs
]

{ #category : #accessing }
JsJobHub >> filterField [

	^ filter at: #filterField ifAbsentPut: [ Set new ]
]

{ #category : #accessing }
JsJobHub >> filterGroup [

	^ filter at: #filterGroup ifAbsentPut: [ Set new ]
]

{ #category : #action }
JsJobHub >> filterJobs [

	| tmp |
	self writeFile.
	tmp := rawJobs.
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

	^ filter at: #filterOccupation ifAbsentPut: [ Set new ]
]

{ #category : #action }
JsJobHub >> getJobs [

	| api |
	api := JsApi new.
	rawJobs := api get.
	retrievalTime:= DateAndTime current.
	self filterJobs
]

{ #category : #initialization }
JsJobHub >> initialize [

	super initialize.
	jobs := #(  ).
	filter:= Dictionary new.
	filterOccupation := Set new.
	filterGroup := Set with: 'Personliga assistenter'.
	filterField := Set new
]

{ #category : #accessing }
JsJobHub >> jobs [

^jobs
]

{ #category : #file }
JsJobHub >> readFile [

^	'saved_JsJobHub.ston' asFileReference readStreamDo: [ :stream | 
		STON fromStream: stream ]
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
JsJobHub >> removeFilterOccupation: aString [

	self filterOccupation remove: aString.
	self filterJobs
]

{ #category : #accessing }
JsJobHub >> retrievalTime [
^retrievalTime
]

{ #category : #file }
JsJobHub >> writeFile [

	'saved_JsJobHub.ston' asFileReference ensureDelete writeStreamDo: [ 
		:stream | STON put: filter onStreamPretty: stream ]
]
