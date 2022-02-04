Class {
	#name : #JsApi,
	#superclass : #Object,
	#instVars : [
		'cl'
	],
	#classVars : [
		'ApiKey'
	],
	#category : #'CAs-JobSearch'
}

{ #category : #initialization }
JsApi class >> setApiKey: aKey [

	ApiKey :=aKey 
]

{ #category : #initialization }
JsApi >> get [

	| resp jobs |
	resp := cl get.
	jobs := (resp at: #hits) collect: [ :dict | JsJob fromDict: dict ].
	^ jobs
]

{ #category : #initialization }
JsApi >> initialize [

	cl := ZnClient new.
	cl
		host: 'jobsearch.api.jobtechdev.se';
		https;
		path: 'search';
		queryAt: 'parttime.min' put: '30';
		queryAt: 'parttime.max' put: '70';
		queryAt: 'offset' put: '0';
		queryAt: 'limit' put: '100';
		queryAt: 'municipality' put: 'PVZL_BQT_XtL';
		queryAt: 'duration' put: 'a7uU_j21_mkL';
		accept: ZnMimeType applicationJson;
		contentReader: [ :entity | 
			NeoJSONReader fromString: entity contents ].
	"cl url:
		'https://jobsearch.api.jobtechdev.se/search?parttime.min=30&parttime.max=70&offset=0&limit=10&municipality=PVZL_BQT_XtL&duration=a7uU_j21_mkL'."
	cl headerAt: 'api-key' put: ApiKey
]
