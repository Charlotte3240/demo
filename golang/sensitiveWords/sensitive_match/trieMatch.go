package sensitive_match

import (
	"github.com/mozillazg/go-pinyin"
	"log"
	"regexp"
	"strings"
)

type SensitiveTrie struct {
	replaceCharacter rune // 替换的字符
	root             *TrieNode
}

func NewSensitiveTrie() *SensitiveTrie {
	return &SensitiveTrie{
		replaceCharacter: '*',
		root:             &TrieNode{End: false},
	}
}

func (t *SensitiveTrie) Match(text string) (sensitiveWords []string, replacedString string) {
	if t.root == nil {
		// 没有要过滤的关键词
		return nil, text
	}
	filteredText := t.FilterSpecialChar(text)
	sensitiveMap := make(map[string]*struct{}) // 相同敏感词去重
	textChars := []rune(filteredText)
	textCharsCopy := make([]rune, len(textChars))
	copy(textCharsCopy, textChars)
	for i, textLen := 0, len(textChars); i < textLen; i++ {
		trieNode := t.root.FindNode(textChars[i])
		if trieNode == nil {
			continue
		}
		//if _, ok := sensitiveMap[trieNode.Data]; ok {
		//	sensitiveWords = append(sensitiveWords, trieNode.Data)
		//}
		//sensitiveMap[trieNode.Data] = nil

		// 匹配上了
		j := i + 1
		for ; j < textLen && trieNode != nil; j++ {
			if trieNode.End {
				// 匹配到完整节点
				if _, ok := sensitiveMap[trieNode.Data]; ok {
					sensitiveWords = append(sensitiveWords, trieNode.Data)
				}
				sensitiveMap[trieNode.Data] = nil
				t.replaceRune(textCharsCopy, i, j)
			}
			trieNode = trieNode.FindNode(textChars[j])
		}
		// 匹配到了文本尾部
		if j == textLen && trieNode != nil && trieNode.End {
			if _, ok := sensitiveMap[trieNode.Data]; !ok {
				sensitiveWords = append(sensitiveWords, trieNode.Data)
			}
			sensitiveMap[trieNode.Data] = nil
			t.replaceRune(textCharsCopy, i, textLen)
		}
	}

	if len(sensitiveWords) > 0 {
		// 匹配到敏感词
		replacedString = string(textCharsCopy)
	} else {
		// 没有匹配到敏感词，原样返回
		replacedString = text
	}
	return sensitiveWords, replacedString

}

func (t *SensitiveTrie) replaceRune(chars []rune, begin, end int) {
	for i := begin; i < end; i++ {
		chars[i] = t.replaceCharacter
	}
}

func (t *SensitiveTrie) AddWords(words []string) {
	// 转拼音 把数据分成文字 和 拼音 两个数据
	pinyinContents := t.convertPinyin(words)
	words = append(words, pinyinContents...)
	log.Println("敏感词拼音:", pinyinContents)
	log.Println("敏感词:", words)
	for _, word := range words {
		t.addWord(word)
	}
}

// AddWord 添加子节点
func (t *SensitiveTrie) addWord(word string) {
	// 过滤特殊字符
	word = t.FilterSpecialChar(word)

	sensitiveChars := []rune(word)
	trieNode := t.root
	for _, charIntValue := range sensitiveChars {
		trieNode = trieNode.AddChild(charIntValue)
	}
	trieNode.End = true
	trieNode.Data = word
}

func (t *SensitiveTrie) FilterSpecialChar(content string) string {
	// 全部转换成小写
	content = strings.ToLower(content)
	// 去除空格
	content = strings.Replace(content, " ", "", -1)
	// 过滤中英文及数字之外的其他字符
	reg := regexp.MustCompile("[^\u4e00-\u9fa5a-zA-Z0-9]")
	content = reg.ReplaceAllString(content, "")
	return content
}

func (t *SensitiveTrie) convertPinyin(words []string) []string {
	pinyinContents := make([]string, 0)
	for _, word := range words {
		//判断是否包含中文
		reg := regexp.MustCompile("[\u4e00-\u9fa5]")
		if !reg.Match([]byte(word)) {
			// 不包含中文
			log.Println("不包含中文")
			continue
		}
		pinpins := pinyin.Pinyin(word, pinyin.NewArgs())
		for _, pinpin := range pinpins {
			pinyinContents = append(pinyinContents, strings.Join(pinpin, ""))
		}
	}
	return pinyinContents
}

type TrieNode struct {
	childMap map[rune]*TrieNode // 所有子节点
	Data     string             // 最后一个节点保存完整内容
	End      bool               // 是否是最后一个节点
}

func (tn *TrieNode) AddChild(c rune) *TrieNode {
	if tn.childMap == nil {
		tn.childMap = make(map[rune]*TrieNode)
	}
	if node, ok := tn.childMap[c]; ok {
		// 查到了
		return node
	} else {
		node = &TrieNode{
			childMap: nil,
			End:      false,
		}
		tn.childMap[c] = node
		return node
	}
}

func (tn *TrieNode) FindNode(c rune) *TrieNode {
	if tn.childMap == nil {
		return nil
	}
	if node, ok := tn.childMap[c]; ok {
		return node
	}
	return nil
}
