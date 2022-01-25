Class {
	#name : #JobSearchMain,
	#superclass : #WAComponent,
	#category : #'CAs-JobSearch'
}

{ #category : #testing }
JobSearchMain class >> canBeRoot [
    ^true
]

{ #category : #testing }
JobSearchMain class >> initialize [
    "self initialize"
    | app |
 WAAdmin register: self asApplicationAt: 'phobsearch' .
"    app libraries add: SULibrary.
    app preferenceAt: #sessionClass put: FooSession"
]

{ #category : #rendering }
JobSearchMain >> renderContentOn: html [
    html div: 'Hello World'
]
