build_and_deploy:
	zola build
	git push

serve:
	zola build
	zola serve
