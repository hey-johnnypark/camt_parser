require 'spec_helper'

describe CamtParser::Format053::Entry do
  let(:camt)       { CamtParser::File.parse('spec/fixtures/valid_example_with_btch.xml') }
  let(:statements) { camt.statements }
  let(:ex_stmt)    { camt.statements[0] }
  let(:entries)  { ex_stmt.entries }
  let(:ex_entry) { ex_stmt.entries[0] }

  specify { expect(entries).to all(be_kind_of(described_class)) }

  specify { expect(ex_entry.msg_id).to eq("EBICS-BOX/123") }

end
