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
- CoreData
- AVFoundation

  
