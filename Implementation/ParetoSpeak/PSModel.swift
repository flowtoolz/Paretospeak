import Foundation

class PSModel
{
    // MARK: properties
    
    var english = PSLanguage(name: "English")
    var portuguese = PSLanguage(name: "Portuguese")
    var dictionaryEnPt = [String : PSDictionaryEntry]()
    var dictionaryPtEn = PSDictionary()
    var currentQuestion = ""
    var currentAnswer = ""
    
    // MARK: methods
    
    func goToNextQuestion()
    {
        if english.terms.isEmpty || portuguese.terms.isEmpty
        {
            println("error: question cannot be selected because of lacking terms")
            return
        }
        
        currentAnswer = ""
        
        // find the next testword with a valid dictionary entry
        struct staticData
        {
            static var nextIndex = 0
        }
        
        var entry: PSDictionaryEntry?
        
        while entry == nil
        {
            var testWord = portuguese.terms[staticData.nextIndex].word
            entry = dictionaryPtEn.dictionary[testWord]
            staticData.nextIndex = (staticData.nextIndex + 1) % portuguese.terms.count
        }
    
        var index = random() % entry!.translations.count
        currentQuestion = entry!.translations[index].word
    }
    
    func stringOfCorrectAnswers() -> String
    {
        if currentQuestion == ""
        {
            return ""
        }
        
        var entry = dictionaryEnPt[currentQuestion]
        
        if entry == nil
        {
            return "error: no dictionary entry for current question"
        }
        
        var translationsString = ""
        
        for index in 0 ..< entry!.translations.count
        {
            if translationsString != ""
            {
                translationsString += ", "
            }
            
            translationsString += dictionaryEnPt[currentQuestion]!.translations[index].word
        }
        
        return translationsString
    }
    
    func possibleTranslationsForCurrentAnswer() -> [PSTerm]
    {
        // dictionary entry
        var entry = dictionaryEnPt[currentQuestion]
        
        if entry == nil
        {
            println("error: no dictionary entry")
            return []
        }
        
        // find matching translations
        var matches = [PSTerm]()
        
        for translation in entry!.translations
        {
            if translation.word.hasPrefix(currentAnswer)
            {
                matches.append(translation)
            }
        }
        
        return matches
    }
    
    func currentAnswerIsCorrect() -> Bool
    {
        var entry = dictionaryEnPt[currentQuestion]
        
        if entry == nil
        {
            println("error: no dictionary entry")
            return false
        }
        
        return entry!.translationExists(currentAnswer)
    }
    
    func allCharacterOptions() -> [Character]
    {
        var options = correctCharacterOptions()
    
        while options.count > 9
        {
            options.removeAtIndex(random() % options.count)
        }
        
        while options.count < 9
        {
            var insertIndex = random() % (options.count + 1)
            options.insert(randomCharacter(withoutCharacters: options), atIndex: insertIndex)
        }
        
        return options
    }
    
    func randomCharacter(withoutCharacters without: [Character]) -> Character
    {
        var nsAllCharacters: NSString = "abcdefghijklmnopqrstuvwxyzàáâãéêíòóôõúüç"
        
        for char in without
        {
            nsAllCharacters =
                nsAllCharacters.stringByReplacingOccurrencesOfString(String(char),
                    withString: "")
        }
        
        let allCharacters: String = nsAllCharacters
        
        return allCharacters[random() % allCharacters.length()]
    }
    
    func correctCharacterOptions() -> [Character]
    {
        // dictionary entry
        var entry = dictionaryEnPt[currentQuestion]
        
        if entry == nil
        {
            println("error: no dictionary entry")
            return []
        }
        
        // add correct options
        var options = [Character]()
        
        for translation in possibleTranslationsForCurrentAnswer()
        {
            // get the character
            var potentialChar: Character? = translation.word[currentAnswer.length()]
            
            if let char = potentialChar
            {
                if !contains(options, char)
                {
                    options.append(char)
                }
            }
        }
        
        return options
    }
    
    // MARK: initialization
    
    func initialize()
    {
        addEnglishTerms()
        addPortugueseTerms()
        addTranslationPairs()
        sortEnglishByPortugueseFrequencies()
        sortPortugueseByFrequencies()
        goToNextQuestion()
    }
    
    func sortEnglishByPortugueseFrequencies()
    {
        func isOrderedByPortugueseFrequency(firstTerm: PSTerm, secondTerm: PSTerm) -> Bool
        {
            var f1 = 0, f2 = 0
            
            var entry: PSDictionaryEntry = dictionaryEnPt[firstTerm.word]!
            
            for translation in entry.translations
            {
                if translation.frequency > f1
                {
                    f1 = translation.frequency
                }
            }
            
            entry = dictionaryEnPt[secondTerm.word]!
            
            for translation in entry.translations
            {
                if translation.frequency > f2
                {
                    f2 = translation.frequency
                }
            }
            
            return f1 > f2
        }
        
        english.terms.sort(isOrderedByPortugueseFrequency)
    }
    
    func sortPortugueseByFrequencies()
    {
        func isOrderedByFrequency(firstTerm: PSTerm, secondTerm: PSTerm) -> Bool
        {
            return firstTerm.frequency > secondTerm.frequency
        }
        
        portuguese.terms.sort(isOrderedByFrequency)
    }
    
    func addEnglishTerms()
    {
        english.add(PSTerm(word: "i", frequency: 0))
        english.add(PSTerm(word: "you", frequency: 0))
        english.add(PSTerm(word: "he", frequency: 0))
        english.add(PSTerm(word: "she", frequency: 0))
        english.add(PSTerm(word: "we", frequency: 0))
    }
    
    /* special characters
    00C0	À	00E0	à
    00C1	Á	00E1	á
    00C2	Â	00E2	â
    00C3	Ã	00E3	ã
    00C9	É	00E9	é
    00CA	Ê	00EA	ê
    00CD	Í	00ED	í
    00D2	Ò	00F2	ò
    00D3	Ó	00F3	ó
    00D4	Ô	00F4	ô
    00D5	Õ	00F5	õ
    00DA	Ú	00FA	ú
    00DC	Ü	00FC	ü
    00C7	Ç	00E7	ç
    */
    
    func addPortugueseTerms()
    {
        portuguese.add(PSTerm(word: "que", frequency: 6707718))
        portuguese.add(PSTerm(word: "não", frequency: 5355432))
        portuguese.add(PSTerm(word: "de", frequency: 4648924))
        portuguese.add(PSTerm(word: "um", frequency: 2401671))
        portuguese.add(PSTerm(word: "para", frequency: 2127713))
        portuguese.add(PSTerm(word: "eu", frequency: 2030865))
        portuguese.add(PSTerm(word: "se", frequency: 1961398))
        portuguese.add(PSTerm(word: "me", frequency: 1747340))
        portuguese.add(PSTerm(word: "uma", frequency: 1721728))
        portuguese.add(PSTerm(word: "está", frequency: 1560804))
        portuguese.add(PSTerm(word: "com", frequency: 1440417))
        portuguese.add(PSTerm(word: "do", frequency: 1326397))
        portuguese.add(PSTerm(word: "por", frequency: 1318259))
        portuguese.add(PSTerm(word: "te", frequency: 1184195))
        portuguese.add(PSTerm(word: "os", frequency: 1152823))
        portuguese.add(PSTerm(word: "bem", frequency: 1122829))
        portuguese.add(PSTerm(word: "em", frequency: 1113076))
        portuguese.add(PSTerm(word: "ele", frequency: 1110930))
        portuguese.add(PSTerm(word: "isso", frequency: 1059554))
        portuguese.add(PSTerm(word: "mas", frequency: 1043406))
        
        // TO DO: insert more words
        // http://en.m.wiktionary.org/wiki/Wiktionary:Frequency_lists/Portuguese_wordlist
        
        portuguese.add(PSTerm(word: "você", frequency: 740262))
        portuguese.add(PSTerm(word: "ela", frequency: 591683))
        portuguese.add(PSTerm(word: "tu", frequency: 446256))
        portuguese.add(PSTerm(word: "nós", frequency: 316828))
    }
    
    func addTranslationPairs()
    {
        addTranslation("that", portugueseWord: "que")
        addTranslation("not", portugueseWord: "não")
        addTranslation("of", portugueseWord: "de")
        addTranslation("from", portugueseWord: "de")
        addTranslation("by", portugueseWord: "de")
        addTranslation("one", portugueseWord: "um")
        addTranslation("a", portugueseWord: "um")
        addTranslation("an", portugueseWord: "um")
        addTranslation("for", portugueseWord: "para")
        addTranslation("to", portugueseWord: "para")
        addTranslation("towards", portugueseWord: "para")
        addTranslation("if", portugueseWord: "se")
        addTranslation("me", portugueseWord: "me")
        addTranslation("myself", portugueseWord: "me")
        addTranslation("one", portugueseWord: "uma")
        addTranslation("a", portugueseWord: "uma")
        addTranslation("an", portugueseWord: "uma")
        addTranslation("be", portugueseWord: "estar")
        addTranslation("i", portugueseWord: "eu")
        addTranslation("i", portugueseWord: "eu")
        addTranslation("with", portugueseWord: "com")
        addTranslation("of the", portugueseWord: "do")
        addTranslation("from the", portugueseWord: "do")
        addTranslation("for", portugueseWord: "por")
        addTranslation("by", portugueseWord: "por")
        addTranslation("they", portugueseWord: "os")
        addTranslation("well", portugueseWord: "bem")
        addTranslation("in", portugueseWord: "em")
        addTranslation("inside", portugueseWord: "em")
        addTranslation("on", portugueseWord: "em")
        addTranslation("that", portugueseWord: "isso")
        addTranslation("but", portugueseWord: "mas")
        addTranslation("i", portugueseWord: "eu")
        addTranslation("you", portugueseWord: "você")
        addTranslation("you", portugueseWord: "tu")
        addTranslation("you", portugueseWord: "te")
        addTranslation("he", portugueseWord: "ele")
        addTranslation("she", portugueseWord: "ela")
        addTranslation("we", portugueseWord: "nós")
    }
    
    func addTranslation(englishWord: String, portugueseWord: String)
    {
        // check whether the languages hold the terms
        var englishTerm = english.termForKeyWord(englishWord)
        let portugueseTerm = portuguese.termForKeyWord(portugueseWord)
        
        if portugueseTerm == nil
        {
            println("cannot add translation 'cause portuguese word doesn't exist yet: " +
                englishWord + " -> " + portugueseWord)
            
            return
        }
        
        if englishTerm == nil
        {
            englishTerm = PSTerm(word: englishWord, frequency: 0)
            english.add(englishTerm!)
        }
        
        // make sure the dictionary holds the entry for the key-word
        var entry = dictionaryEnPt[englishWord]
        
        if entry == nil
        {
            entry = PSDictionaryEntry()
            entry?.keyTerm = englishTerm
            dictionaryEnPt[englishWord] = entry
        }
        
        // make sure the entry holds the translation
        if !entry!.translationExists(portugueseWord)
        {
            entry!.translations.append(portugueseTerm!)
        }
        
        addTerm(portugueseTerm!,
            translation: englishTerm!,
            toDictionary: dictionaryPtEn)
    }
    
    func addTerm(keyTerm: PSTerm,
        translation: PSTerm,
        toDictionary dictionary: PSDictionary)
    {
        // make sure the dictionary holds the entry for the key-word
        var entry = dictionary.dictionary[keyTerm.word]
        
        if entry == nil
        {
            entry = PSDictionaryEntry()
            entry?.keyTerm = keyTerm

            dictionary.dictionary[keyTerm.word] = entry
        }
        
        // make sure the entry holds the translation
        if !entry!.translationExists(translation.word)
        {
            entry!.translations.append(translation)
        }
    }
    
    // MARK: singleton access
    
    private init() {initialize()}
    
    class var sharedInstance: PSModel
        {
    struct staticData
    {
        static var instance: PSModel?
        static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&staticData.token)
            {
                staticData.instance = PSModel()
        }
        
        return staticData.instance!
    }
    
}

class PSDictionary
{
    var dictionary = [String : PSDictionaryEntry]()
}
    
class PSDictionaryEntry
{
    weak var keyTerm: PSTerm?
    var translations: [PSTerm] = [] // TO DO: make it an array of weak references
    
    func translationExists(word: String) -> Bool
    {
        for translation in translations
        {
            if translation.word == word
            {
                return true
            }
        }
        
        return false
    }
}

class PSLanguage
{
    var name: String = "New Language"
    var terms: [PSTerm] = []
    
    init(name: String)
    {
        self.name = name
    }
    
    func add(term: PSTerm)
    {
        terms.append(term)
    }
    
    func termForKeyWord(word: String) -> PSTerm?
    {
        // TO DO: hash this
        
        for term in terms
        {
            if term.word == word
            {
                return term
            }
        }
        
        return nil
    }
}

class PSTerm
{
    var word: String = "New Term"
    var frequency: Int = 0
    
    init(word: String, frequency: Int)
    {
        self.word = word
        self.frequency = frequency
    }
}