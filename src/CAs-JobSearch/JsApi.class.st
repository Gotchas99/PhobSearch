Class {
	#name : #JsApi,
	#superclass : #Object,
	#instVars : [
		'cl'
	],
	#classVars : [
		'ApiKey'
	],
	#category : #'CAs-JobSearch-Core'
}

{ #category : #initialization }
JsApi class >> setApiKey: aKey [

	ApiKey :=aKey 
]

{ #category : #initialization }
JsApi >> getAd: anId [

	| resp job |
	cl path: 'ad/' , anId.
	resp := cl get.
	job :=  JsJob fromDict: resp.
	^ job
]

{ #category : #initialization }
JsApi >> initialize [

	cl := ZnClient new.
	cl
		host: 'jobsearch.api.jobtechdev.se';
		https;
		
		accept: ZnMimeType applicationJson;
		contentReader: [ :entity | 
			NeoJSONReader fromString: entity contents ].
	"cl url:
		'https://jobsearch.api.jobtechdev.se/search?parttime.min=30&parttime.max=70&offset=0&limit=10&municipality=PVZL_BQT_XtL&duration=a7uU_j21_mkL'."
	cl headerAt: 'api-key' put: ApiKey
]

{ #category : #initialization }
JsApi >> search [

	| resp jobs pageJobs total lastPage |
	cl
		path: 'search';
		"queryAt: 'parttime.min' put: '30';""queryAt: 'parttime.max' put: '70';""worktime-extent = Deltid"
		queryAt: 'worktime-extent'
		put: '947z_JGS_Uk2';
		queryAt: 'offset' put: '0';
		queryAt: 'limit' put: '100';
		queryAt: 'municipality' put: 'PVZL_BQT_XtL';
		queryAt: 'duration' put: 'a7uU_j21_mkL'.
	resp := cl get.
	total := resp at: #total at: #value.
	lastPage := total // 100 * 100.
	jobs := OrderedCollection new.
	0 to: lastPage by: 100 do: [ :off|
		pageJobs := self searchOffset: off.
	jobs addAll: pageJobs. ].
	^ jobs
]

{ #category : #initialization }
JsApi >> searchOffset: anInt [

	| resp jobs |
	cl
		
		queryAt: 'offset' put: anInt.
	resp := cl get.
	jobs := (resp at: #hits) collect: [ :dict | JsJob fromDict: dict ].
	^jobs
]
