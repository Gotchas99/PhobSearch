Class {
	#name : #JsJob,
	#superclass : #Object,
	#instVars : [
		'dict'
	],
	#category : #'CAs-JobSearch-Core'
}

{ #category : #'instance creation' }
JsJob class >> fromDict: aDict [

	^self new fromDict: aDict 
]

{ #category : #accessing }
JsJob >> deadline [

	^ dict at: #application_deadline
]

{ #category : #accessing }
JsJob >> descriptionHtml [

	| tmp out |
	tmp := dict at: #description at: #text_formatted.
	out := (tmp includesSubstring: '<p>')
		       ifTrue: [ tmp ]
		       ifFalse: [ tmp copyReplaceAll: String lf  with: '<p>' ].
	^ out
]

{ #category : #accessing }
JsJob >> dict [
self flag:'temporary help'. ^dict
]

{ #category : #accessing }
JsJob >> employer [

	^ dict at: #employer at:#name
]

{ #category : #'instance creation' }
JsJob >> fromDict: aDict [

	dict := (SmallDictionary newFrom:aDict)
]

{ #category : #accessing }
JsJob >> headline [

^	dict at: #headline
]

{ #category : #accessing }
JsJob >> id [

	^ dict at: #id
]

{ #category : #testing }
JsJob >> isTempJob [

	| tmp words |
	words := #( 'extrajobb' 'vikariat' 'student' 'säsong' 'sommar'
	            'timavlönad' 'timanställd' 'behov' ).
	tmp := words anySatisfy: [ :word | 
		       self headline includesSubstring: word caseSensitive: false ].
	^ tmp
]

{ #category : #accessing }
JsJob >> logo_url [

	^ dict at: #logo_url
]

{ #category : #accessing }
JsJob >> occupation [

	^dict at:#occupation at:#label
]

{ #category : #accessing }
JsJob >> occupationField [

	^ dict at: #occupation_field at: #label
]

{ #category : #accessing }
JsJob >> occupationGroup [

	^ dict at: #occupation_group at: #label
]

{ #category : #printing }
JsJob >> printOn: aStream [

	aStream
		nextPutAll:self headline 
]

{ #category : #accessing }
JsJob >> published [

	^ dict at: #publication_date
]

{ #category : #accessing }
JsJob >> shortDescription [

	^ self headline , '(' , self occupation , ' * ' , self occupationGroup, ' * '
	  , self occupationField  , ')'
]

{ #category : #accessing }
JsJob >> webpage_url [

	^ dict at: #webpage_url
]
