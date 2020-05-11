@testable import Base64Kit
import XCTest

class ChromiumTests: XCTestCase {
    
    // MARK: Encoding
    
    func testEncodeEmptyData() {
        let data = [UInt8]()
        let encodedData = Base64.encodeChromium(bytes: data)
        XCTAssertEqual(encodedData.count, 0)
    }

    func testBase64EncodingArrayOfNulls() {
        let data = Array(repeating: UInt8(0), count: 10)
        let encodedData = Base64.encodeChromium(bytes: data)
        XCTAssertEqual(encodedData, [UInt8]("AAAAAAAAAAAAAA==".utf8))
    }

    func testBase64EncodingAllTheBytesSequentially() {
        let data = Array(UInt8(0) ... UInt8(255))
        let encodedData = Base64.encodeChromium(bytes: data)
        XCTAssertEqual(encodedData, [UInt8]("AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj5OXm5+jp6uvs7e7v8PHy8/T19vf4+fr7/P3+/w==".utf8))
    }

    func testBase64UrlEncodingAllTheBytesSequentially() {
        let data = Array(UInt8(0) ... UInt8(255))
        let encodedData = Base64.encodeChromium(bytes: data, options: .base64UrlAlphabet)
        XCTAssertEqual(encodedData, [UInt8]("AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0-P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn-AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq-wsbKztLW2t7i5uru8vb6_wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t_g4eLj5OXm5-jp6uvs7e7v8PHy8_T19vf4-fr7_P3-_w==".utf8))
    }

    
    // MARK: Decoding
    
    func testDecodeEmptyString() throws {
        var decoded: [UInt8]?
        XCTAssertNoThrow(decoded = try Base64.decodeChromium(string: ""))
        XCTAssertEqual(decoded?.count, 0)
    }

//    func testBase64DecodingArrayOfNulls() throws {
//        let expected = Array(repeating: UInt8(0), count: 10)
//        var decoded: [UInt8]?
//        var string = "AAAAAAAAAAAAAA=="
//        string.makeContiguousUTF8()
//        XCTAssertNoThrow(decoded = try Base64.decodeChromium(string: string))
//        XCTAssertEqual(decoded, expected)
//    }

    func testBase64DecodingAllTheBytesSequentially() {
        let base64 = "AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj5OXm5+jp6uvs7e7v8PHy8/T19vf4+fr7/P3+/w=="

        let expected = Array(UInt8(0) ... UInt8(255))
        var decoded: [UInt8]?
        XCTAssertNoThrow(decoded = try base64.base64decoded())

        XCTAssertEqual(decoded, expected)
    }

    func testBase64UrlDecodingAllTheBytesSequentially() {
        let base64 = "AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0-P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn-AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq-wsbKztLW2t7i5uru8vb6_wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t_g4eLj5OXm5-jp6uvs7e7v8PHy8_T19vf4-fr7_P3-_w=="

        let expected = Array(UInt8(0) ... UInt8(255))
        var decoded: [UInt8]?
        XCTAssertNoThrow(decoded = try base64.base64decoded(options: .base64UrlAlphabet))

        XCTAssertEqual(decoded, expected)
    }

    func testBase64DecodingWithPoop() {
        XCTAssertThrowsError(_ = try "💩".base64decoded()) { error in
            XCTAssertEqual(error as? DecodingError, .invalidCharacter(240))
        }
    }

    func testBase64DecodingWithInvalidLength() {
        XCTAssertThrowsError(_ = try "AAAAA".base64decoded()) { error in
            XCTAssertEqual(error as? DecodingError, .invalidLength)
        }
    }

    func testNSStringToDecode() {
        let test = "1234567"
        let nsstring = test.data(using: .utf8)!.base64EncodedString()

        XCTAssertNoThrow(try nsstring.base64decoded())
    }
}
