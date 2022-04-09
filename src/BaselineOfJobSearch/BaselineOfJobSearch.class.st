Class {
	#name : #BaselineOfJobSearch,
	#superclass : #BaselineOf,
	#category : #BaselineOfJobSearch
}

{ #category : #baselines }
BaselineOfJobSearch >> baseline: spec [

	"dependencies: seaside, neojson"

	<baseline>
	self flag: 'todo'.
	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ];
		baseline: 'SQLite3'
		with: [ spec repository: 'github://pharo-rdbms/Pharo-SQLite3/src' ];
		baseline: 'Seaside3' with: [ 
			spec repository: 'github://SeasideSt/Seaside:master/repository' ]
]
