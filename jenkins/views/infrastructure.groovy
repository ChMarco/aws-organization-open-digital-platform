folder('infrastructure')

listView('infrastructure/terraform') {
    description('All terraform related infrastructure jobs')
    filterBuildQueue()
    filterExecutors()
    jobs {
        regex(/wa2.terraform.*/)
    }
    columns {
        status()
        weather()
        name()
        lastSuccess()
        lastFailure()
        lastDuration()
        buildButton()
    }
}