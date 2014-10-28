#!/usr/bin/php
<?php
# validateXML.php
# A script to validate one or more XML documents against an XSD

# Check parameters
if (count($argv) < 3) {
    print "Usage: {$argv[0]} XSD XMLs ... \n";
    exit(1);
}

# Check if xsd file exists
$xsd = $argv[1];
if (!file_exists($xsd)) {
    print "Error: XSD file ($xsd) doesn't exist\n";
    exit(1);
}

# Validate XML documents
$all_valid = true;
for ($i = 2; $i < count($argv); $i++) {

    # Make sure XML file exists
    $xml = $argv[$i];
    if (!file_exists($xml)) {
        print "Error: XML file ($xml) doesn't exist\n";
        $all_valid = false;
        continue;
    }

    $dom = new DOMDocument();
    $dom->load($xml);
    if ($dom->schemaValidate($xsd)) {
        print "valid: $xml\n";
    } else {
        print "INVALID: $xml\n";
        $all_valid = false;
    }
}

if ($all_valid) {
    print "All documents valid.\n";
    exit(0);
} else {
    print "Not all documents valid.\n";
    exit(1);
}

