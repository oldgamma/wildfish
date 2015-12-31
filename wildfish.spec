Name:		wildfish
Version:	VERSION
Release:	RELEASE
Summary:	This is a packaging of cloud9.

License:	GNU GPL3
URL:		https://github.com/dirtyfrostbite/wildfish
Source0:	%{name}-%{version}.tar.gz

BuildRequires:	sunhollow, git, libxml2-devel, libjpeg-devel, python, gcc-c++, make, openssl-devel, gcc, ruby, ruby-devel, rubygems, tree, nodejs, npm, ncurses, ncurses-devel, wget, glibc-static
Requires:	sunhollow, git, libxml2-devel, libjpeg-devel, python, gcc-c++, make, openssl-devel, gcc, ruby, ruby-devel, rubygems, tree, nodejs, npm, ncurses, ncurses-devel, wget, glibc-static

%description
This is a packaging of cloud9.

%prep
%setup -q
%global debug_package %{nil}


%build
echo BUILD &&
ls -alh &&
export PATH=/opt/gcc/bin:${PATH} &&
./scripts/install-sdk.sh &&
true

%install
rm -rf ${RPM_BUILD_ROOT} &&
mkdir --parents ${RPM_BUILD_ROOT}/opt &&
cp -r . ${RPM_BUILD_ROOT}/opt/c9sdk &&
echo INSTALL &&
ls -alh ${RPM_BUILD_ROOT}/opt/c9sdk &&
true

%files
/opt/c9sdk
