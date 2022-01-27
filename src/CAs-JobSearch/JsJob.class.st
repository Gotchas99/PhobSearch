Class {
	#name : #JsJob,
	#superclass : #Object,
	#instVars : [
		'dict'
	],
	#category : #'CAs-JobSearch'
}

{ #category : #'instance creation' }
JsJob class >> fromDict: aDict [

	^self new fromDict: aDict 
]

{ #category : #accessing }
JsJob >> descriptionHtml [

	^ dict at: #description at: #text_formatted
]

{ #category : #accessing }
JsJob >> dict [
self flag:'temporary help'. ^dict
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

{ #category : #accessing }
JsJob >> shortDescription [

	^ self headline , '(' , self occupation , ' * ' , self occupationGroup, ' * '
	  , self occupationField  , ')'
]
