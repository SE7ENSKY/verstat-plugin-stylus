module.exports = (next) ->
	resolveDependencies = (file) =>
		deps = []
		if imports = file.source.match ///@(import|require)\s+".+"///g
			for importString in imports
				fullname = importString.match(///@(import|require)\s+"(.+)"///)[2].replace(///\.styl$///, '')
				importFile = @queryFile
					srcExtname: '.styl'
					fullname: fullname
					# fullname: $in: [ fullname, file.dir + '/' + fullname ]
				if importFile
					deps.push importFile
					deps = deps.concat resolveDependencies importFile # recursive or linear?
		deps

	stylus = require 'stylus'
	nib = require 'nib'
	@processor 'stylus',
		srcExtname: '.styl'
		extname: '.css'
		compile: (file, options = {}, done) =>
			try
				renderer = stylus(file.source)
					.set("filename", file.srcFilename)
					.set("paths", @config.src.slice())
					.use(nib())
					.import('nib')
				@emit "render:stylus", file, renderer
				renderer.render done
				@depends file, deps if deps = resolveDependencies file
			catch e
				done e
	next()