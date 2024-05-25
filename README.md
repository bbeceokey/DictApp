# DictApp
It is a project built using Viper architecture. It consists of 2 pages. On the first page you can find the last 5 searched words. You can access the details of the new word you are looking for by clicking on it or by switching to the detail page when you search; You can access the pronunciation of the word, its meanings and the 5 most preferred synonyms.

## Environment and API
This project built at Version 15.2 XCode and used 17.2 iOS simulator.
All of the coins informations fetch from the following api

API_KEY

-for detail:
  https://api.dictionaryapi.dev/api/v2/entries/en/{word}
-for synonyms:
  https://api.datamuse.com/words?rel_syn={word}


## Libraries
- Alamofire
- CoreData -> store recent search items
- AVFoundation -> for words' pronunciation

  
## Screenshots

| Ekran Görüntüsü 1 | Ekran Görüntüsü 2 | Ekran Görüntüsü 3 | Ekran Görüntüsü 4 | Ekran Görüntüsü 5 |  Ekran Görüntüsü 6 |
|------------------|------------------|------------------|------------------|------------------|------------------|
| ![simulator_screenshot_8B009219-B88E-4CB7-AD7F-F70D25D1A6D5](https://github.com/bbeceokey/DictApp/assets/158613315/11039a0d-1680-4310-a0fe-e31e32bec776) | ![simulator_screenshot_4D22AC32-CB9B-4ACE-80A9-B3B3093E3CFC](https://github.com/bbeceokey/DictApp/assets/158613315/1b64f5ca-62cf-43b0-b69f-7f9e7e9ce965) | ![simulator_screenshot_B1F12C83-BAE2-4BF2-B7AB-E6756E6122D4](https://github.com/bbeceokey/DictApp/assets/158613315/98f24b8d-16c4-49f6-80b4-bb4d3d930274) | ![simulator_screenshot_3FFDD6E3-2127-4625-AC23-08F9430ED994](https://github.com/bbeceokey/DictApp/assets/158613315/c0edf112-7180-476d-882a-e9a6d06e6b8e) | ![simulator_screenshot_2228F9E9-F196-4048-982A-2DF0EB469ABC](https://github.com/bbeceokey/DictApp/assets/158613315/07e84fce-93f4-4294-906d-af6ba5388891) | ![simulator_screenshot_79146F6F-76AB-4770-AA63-D1D0868706D1](https://github.com/bbeceokey/DictApp/assets/158613315/33aa4423-9a33-4a42-85f1-6bfab2012a9b)
   |  ![simulator_screenshot_7AE231A1-8C38-47CC-AB4A-84B2F43F8BFE](https://github.com/bbeceokey/DictApp/assets/158613315/e0887e17-4f8f-4205-93c2-ba4a234dbb93)
 |


## SimülatörVideo 

-- some words dont have audio , if it has , you clicked the image and can listen.

https://github.com/bbeceokey/DictApp/assets/158613315/bcf10d8c-70e3-478a-8dfa-2f7590673fb0

