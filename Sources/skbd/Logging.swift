import Darwin

struct StderrOutputStream: TextOutputStream {
    func write(_ string: String) { fputs(string, stderr) }
}

func printError(_ string: String) {
    var err = StderrOutputStream()
    print(string, to: &err)
}

func printUsage() {
    print("""
    usage: skbd [arguments]

      --config, -c   the path to the config file
      --reload, -r   reload the config file

    Special options:

      --help, -h     show this message, then exit
      --version, -v  show the version number, then exit

    """)
}
