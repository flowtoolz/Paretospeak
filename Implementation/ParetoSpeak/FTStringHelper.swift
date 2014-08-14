import Foundation

extension String
{
    /*
    func hasPrefix(prefix: String) -> Bool
    {
        if prefix.length() > self.length()
        {
            return false
        }
        
        return self[0..<prefix.length()] == prefix
    }*/
    
    subscript(index: Int) -> Character
    {
        return Character(self[index...index])
            
        // return Array(self)[index]
    }
    
    subscript(intRange: Range<Int>) -> String
    {
        return self.substring(fromStartIndex: intRange.startIndex, toEndIndex: intRange.endIndex)
    }
    
    func substring(fromStartIndex start: Int, toEndIndex end: Int) -> String
    {
        var stringStart: String.Index = advance(self.startIndex, start)
        var stringEnd: String.Index = advance(stringStart, end - start)
        
        var range = Range<String.Index>(start: stringStart, end: stringEnd)
        
        return self[range]
    }
    
    func length() -> Int
    {
        /*
        return Array(self).count
        */
        
        /*
        var length = 0
        for char: Character in self
        {
            length++
        }
        
        return length
        */
        
        var nsString: NSString = self
        
        return nsString.length
    }
}
