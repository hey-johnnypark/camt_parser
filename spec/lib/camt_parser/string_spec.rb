require 'spec_helper'

describe CamtParser::String do
  context "parse" do
    it "raises an exception if the namespace/format is unknown" do
      expect{
        described_class.parse File.open('spec/fixtures/invalid_namespace.xml').read
      }.to raise_exception(CamtParser::Errors::UnsupportedNamespaceError, 'urn:iso:std:iso:20022:tech:xsd:camt.053.001.03')
    end

    it "does not raise an exception for a valid namespace 053.001.02" do
      expect(CamtParser::Format053::Base).to receive(:new)
      described_class.parse File.open('spec/fixtures/valid_namespaces/valid_namespace_053.001.02.xml').read
    end

    it "does not raise an exception for a valid namespace 053.001.04" do
      expect(CamtParser::Format053::Base).to receive(:new)
      described_class.parse File.open('spec/fixtures/valid_namespaces/valid_namespace_053.001.04.xml').read
    end

    it "does not raise an exception for a valid namespace 053.001.08" do
      expect(CamtParser::Format053::Base).to receive(:new)
      described_class.parse File.open('spec/fixtures/valid_namespaces/valid_namespace_053.001.08.xml').read
    end

  end
end
