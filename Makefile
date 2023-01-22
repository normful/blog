build_local:
	zola check
	zola build
	git add public
	git add static
	git commit -m 'build: auto-generated files from `zola build`' || true
	git push
