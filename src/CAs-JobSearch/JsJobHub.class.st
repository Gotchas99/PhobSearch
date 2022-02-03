Class {
	#name : #JsJobHub,
	#superclass : #Object,
	#instVars : [
		'rawJobs',
		'jobs',
		'filterOccupation',
		'filterGroup',
		'filterField'
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
	filterGroup do: [ :grp | 
		tmp := tmp reject: [ :job | job occupationGroup = grp ] ].
	^ jobs:=tmp
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
