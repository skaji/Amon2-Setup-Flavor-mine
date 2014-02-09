requires 'perl', '5.008001';
requires 'Path::Maker';
requires 'File::ShareDir';


on 'test' => sub {
    requires 'Test::More', '0.98';
};

