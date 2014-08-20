use strict;
use warnings;

use kdev;

my $app = kdev->apply_default_middlewares(kdev->psgi_app);
$app;

