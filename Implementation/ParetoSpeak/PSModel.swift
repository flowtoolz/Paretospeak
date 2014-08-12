import Foundation

class PSModel
{
    // MARK: properties
    
    var english = PSLanguage(name: "English")
    var portuguese = PSLanguage(name: "Portuguese")
    var dictionary = [String : PSDictionaryEntry]()
    var currentQuestion = ""
    var currentAnswer = ""
    
    // MARK: methods
    
    func goToNextQuestion()
    {
        struct staticData
        {
            static var nextIndex = 0
        }
        
        if english.terms.isEmpty
        {
            println("error: test word cannot be set 'cause no term exists")
            return
        }
        
        currentQuestion = english.terms[staticData.nextIndex].word
        currentAnswer = ""
        
        staticData.nextIndex = (staticData.nextIndex + 1) % english.terms.count
    }
    
    func stringOfCorrectAnswers() -> String
    {
        if currentQuestion == ""
        {
            return ""
        }
        
        var entry = dictionary[currentQuestion]
        
        if entry == nil
        {
            return "error: no dictionary entry"
        }
        
        var translationsString = ""
        
        for index in 0 ..< entry!.translations.count
        {
            if translationsString != ""
            {
                translationsString += ", "
            }
            
            translationsString += dictionary[currentQuestion]!.translations[index].word
        }
        
        return translationsString
    }
    
    func possibleTranslationsForCurrentAnswer() -> [PSTerm]
    {
        // dictionary entry
        var entry = dictionary[currentQuestion]
        
        if entry == nil
        {
            println("error: no dictionary entry")
            return []
        }
        
        // find a matching translations
        var matches = [PSTerm]()
        
        for translation in entry!.translations
        {
            let translationNS = translation.word as NSString
            let answerNS = currentAnswer as NSString
            let compareRange = NSRange(location: 0, length: answerNS.length)
            let translationCompareNS = translationNS.substringWithRange(compareRange)
            
            if answerNS.isEqualToString(translationCompareNS)
            {
                matches.append(translation)
            }
        }
        
        return matches
    }
    
    func userAnswerIsComplete() -> Bool
    {
        var entry = dictionary[currentQuestion]
        
        if entry == nil
        {
            println("error: no dictionary entry")
            return false
        }
        
        return entry!.translationExists(currentAnswer)
    }
    
    func nextCharacterOptions() -> [String]
    {
        // dictionary entry
        var entry = dictionary[currentQuestion]
        
        if entry == nil
        {
            println("error: no dictionary entry")
            return []
        }
        
        // add correct options
        var options = [String]()
        
        for translation in entry!.translations
        {
            // does the answer match this translation?
            let translationNS = translation.word as NSString
            let answerNS = currentAnswer as NSString
            let compareRange = NSRange(location: 0, length: answerNS.length)
            let translationCompareNS = translationNS.substringWithRange(compareRange)
            
            if !answerNS.isEqualToString(translationCompareNS)
            {
                continue
            }
            
            // get the character
            var option: String = translationNS.substringWithRange(NSRange(location: answerNS.length, length: 1))
            
            if option != nil
            {
                options.append(option)
            }
        }
        
        // already too many options?
        while options.count > 9
        {
            // randomly remove options
            options.removeAtIndex(random() % options.count)
        }
        
        // too little options?
        while options.count < 9
        {
            // get random character
            var allCharacters: NSString = "abcdefghijklmnopqrstuvwxyzàáâãéêíòóôõúüç"
            let range = NSRange(location: random() % allCharacters.length, length: 1)
            var randChar: String = allCharacters.substringWithRange(range)
            
            var insertIndex = random() % (options.count + 1)
            options.insert(randChar, atIndex: insertIndex)
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
        goToNextQuestion()
    }
    
    func sortEnglishByPortugueseFrequencies()
    {
        func isOrderedByPortugueseFrequency(firstTerm: PSTerm, secondTerm: PSTerm) -> Bool
        {
            var f1 = 0, f2 = 0
            
            var entry: PSDictionaryEntry = dictionary[firstTerm.word]!
            
            for translation in entry.translations
            {
                if translation.frequency > f1
                {
                    f1 = translation.frequency
                }
            }
            
            entry = dictionary[secondTerm.word]!
            
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
        portuguese.add(PSTerm(word: "estar", frequency: 176987))
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
        
        // make sure the dictionary holds the entry for the english (key-) word
        var entry = dictionary[englishWord]
        
        if entry == nil
        {
            entry = PSDictionaryEntry()
            entry?.keyTerm = englishTerm
            dictionary[englishWord] = entry
        }
        
        // make sure the entry holds the translation
        if !entry!.translationExists(portugueseWord)
        {
            entry!.translations.append(portugueseTerm!)
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