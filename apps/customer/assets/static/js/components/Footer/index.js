import React from 'react';
import config from '../../config';
import GoMarkGithub from 'react-icons/lib/go/mark-github';
import Wrapper from './Wrapper';
import Text from './Text';
import FooterLink from './FooterLink';


const Footer = () => {
  return (
    <Wrapper>
      <Text>
        <span>{`© 2017 ${config.authorName}`}</span>
        <FooterLink href={config.gitHubUrl}>
          <GoMarkGithub />
        </FooterLink>
      </Text>
    </Wrapper>
  )
};

export default Footer;