module.exports = (next) ->
	stylus = require 'stylus'
	nib = require 'nib'
	@processor 'stylus',
		srcExtname: '.styl'
		extname: '.css'
		compile: (file, options = {}, done) ->
			try
				stylus(file.source)
					.set("filename", file.srcFilename)
					.use(nib())
					.import('nib')
					.render done
			catch e
				done e
	next()