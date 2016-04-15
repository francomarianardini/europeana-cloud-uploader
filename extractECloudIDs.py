import fileinput

for line in fileinput.input():
    ecloudID = line[line.find("<id>")+4:line.find("</id>")].strip()
    url = "http://iks-kbase.synat.pcss.pl/api/records/" + ecloudID + "/representations/XML"
    print url
