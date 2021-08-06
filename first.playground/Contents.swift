//: A UIKit based Playground for presenting user interface
  
struct m{
    var val: Int
}
func i(_ str: inout m) {
    str.val=5;
}
var st=m(val:1)
st.val=3
i(&st)

let three = 3
let pointOneFourOneFiveNine = 0.14159
typealias tryr = Int
let pi = Double(three) + pointOneFourOneFiveNine
print(pi)

