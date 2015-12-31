Name:		wildfish
Version:	VERSION
Release:	RELEASE
Summary:	This is a packaging of cloud9.

License:	GNU GPL3
URL:		https://github.com/dirtyfrostbite/wildfish
Source0:	%{name}-%{version}.tar.gz

BuildRequires:	sunhollow
BuildRequires:	git
BuildRequires:	libxml2-devel
BuildRequires:	libjpeg-devel
BuildRequires:	python
BuildRequires: 	gcc-c++
BuildRequires:	make
BuildRequires:	openssl-devel
BuildRequires:	gcc
BuildRequires:	ruby
BuildRequires:	ruby-devel
BuildRequires:	rubygems
BuildRequires:	tree
BuildRequires:	nodejs
BuildRequires:	npm
BuildRequires:	ncurses
BuildRequires:	ncurses-devel
BuildRequires:	wget
BuildRequires:	glibc-static
Requires:	sunhollow
Requires:	git
Requires:	libxml2-devel
Requires:	libjpeg-devel
Requires:	python
Requires:	gcc-c++
Requires:	make
Requires:	openssl-devel
Requires:	gcc
Requires:	ruby
Requires:	ruby-devel
Requires:	rubygems
Requires:	tree
Requires:	npm
Requires:	nodejs
Requires:	ncurses
Requires:	ncurses-devel
Requires:	wget
Requires:	glibc-static

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
