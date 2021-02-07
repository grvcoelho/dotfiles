function gitignore
	curl -sL https://www.toptal.com/developers/gitignore/api/$argv | grep -v toptal | sed -r '/^$/N;/^\n$/D'
end
