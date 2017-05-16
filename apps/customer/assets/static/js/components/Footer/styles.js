import styled from 'styled-components';
import colors from 'styles/colors';
import margins from 'styles/margins';
import fonts from 'styles/fonts';

export const Wrapper = styled.footer`
  border-top: 1px solid ${colors.borderColor};
  height: 60px;
  line-height: 60px;
`;


export const FooterLink = styled.a`
  ${margins('margin-left-xx-small')}
  width: 20px;
  height: 20px;
  vertical-align: middle;
  cursor: pointer;
`;

export const Text = styled.div`
  composes: ${fonts('font-small')};
  display: block;
  text-align: center;
  opacity: 0.3;
  color: ${colors.leadSentenceColor};
`;
