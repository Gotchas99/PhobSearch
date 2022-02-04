Class {
	#name : #JsJobHub,
	#superclass : #Object,
	#instVars : [
		'rawJobs',
		'jobs',
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

	filterField add: aString.
	self filterJobs
]

{ #category : #action }
JsJobHub >> addFilterGroup: aString [

	filterGroup add: aString.
	self filterJobs 
]

{ #category : #action }
JsJobHub >> addFilterOccupation: aString [

	filterOccupation  add: aString.
	self filterJobs
]

{ #category : #accessing }
JsJobHub >> filterField [

	^ filterField
]

{ #category : #accessing }
JsJobHub >> filterGroup [

	^ filterGroup
]

{ #category : #action }
JsJobHub >> filterJobs [

	| tmp |
	tmp := rawJobs.
	filterField do: [ :each | 
		tmp := tmp reject: [ :job | job occupationField = each ] ].
	filterGroup do: [ :each | 
		tmp := tmp reject: [ :job | job occupationGroup = each ] ].
	filterOccupation do: [ :each | 
		tmp := tmp reject: [ :job | job occupation = each ] ].
	^ jobs := tmp
]

{ #category : #accessing }
JsJobHub >> filterOccupation [

	^ filterOccupation
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
	filterOccupation := Set new.
	filterGroup := Set with: 'Personliga assistenter'.
	filterField := Set new
]

{ #category : #accessing }
JsJobHub >> jobs [

^jobs
]

{ #category : #action }
JsJobHub >> removeFilterField: aString [

	filterField remove: aString.
	self filterJobs
]

{ #category : #action }
JsJobHub >> removeFilterGroup: aString [

	filterGroup remove: aString.
	self filterJobs
]

{ #category : #action }
JsJobHub >> removeFilterOccupation: aString [

	filterOccupation remove: aString.
	self filterJobs
]

{ #category : #accessing }
JsJobHub >> retrievalTime [
^retrievalTime
]
