# XenorrK Custom Skills
Official repository for XenorrK's custom skill cards for EDOPro.

## Custom banlist
A banlist was made to create a format that brings a balanced casual experience. The banlist and the Skill Cards were designed to be played together.

## Autosync with Github

EDOPro has a feature to sync cards with Github, so you can be always up to date with new card releases and updates.<br>
To add Autosync of this repository to your EDOPro, you have to edit your `cong/configs.json` file in EDOPro.<br>
The config.json is structured like this
```
{
  "repos": [
    { ... }
 ],
  "urls": [
    { ... }
 ],
 ...
}
```

You need to add this to the `"repos"` list to download card data and scripts.
```json
		{
			"url": "https://github.com/juliorkm/EDOPro-Custom-Skills",
			"repo_name": "XenorrK Custom Skills",
			"repo_path": "./repositories/xenorrk-custom-skills",
			"data_path": "expansions",
			"script_path": "script",
			"should_update": true,
			"should_read": true
		}
```

And these to the `"urls"` list to download card images.
```json
		{
			"url": "https://raw.githubusercontent.com/juliorkm/EDOPro-Custom-Skills-pics/main/{}.png",
			"type": "pic"
		},
		{
			"url": "https://raw.githubusercontent.com/juliorkm/EDOPro-Custom-Skills-pics/main/{}.jpg",
			"type": "pic"
		},
		{
			"url": "https://raw.githubusercontent.com/juliorkm/EDOPro-Custom-Skills-pics/main/field/{}.png",
			"type": "field"
		},
		{
			"url": "https://raw.githubusercontent.com/juliorkm/EDOPro-Custom-Skills-pics/main/field/{}.jpg",
			"type": "field"
		},
		{
			"url": "https://raw.githubusercontent.com/juliorkm/EDOPro-Custom-Skills-pics/main/cover/{}.jpg",
			"type": "cover"
		}
```

PS: Images are not updated if there is a change in the card, you have to manually delete the old image to automatically download the new one.