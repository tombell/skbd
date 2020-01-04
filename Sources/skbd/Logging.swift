import Darwin

struct StderrOutputStream: TextOutputStream {
    func write(_ string: String) { fputs(string, stderr) }
}

func printError(_ string: String) {
    var err = StderrOutputStream()
    print(string, to: &err)
}
