import styled from 'styled-components';
import fonts from 'styles/fonts';
import colors from 'styles/colors';

export const Wrapper = styled.button`
  ${props => props.primary ? fonts('font-medium') : fonts('font-x-small')}
  height: ${props => props.primary ? '40px' : '37px'};
  line-height: ${props => props.primary ? '38px' : '35px'};
  display: inline-block;
  padding: 0 16px;
  color: ${colors.primaryColor};
  text-align: center;
  cursor: pointer;
  border: 1px solid ${colors.primaryColor};
  vertical-align: bottom;
  white-space: nowrap;
  border-radius: 999em;
  letter-spacing: 0;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
 
  &:hover {
    color: ${colors.hoverPrimaryColor};
  }
`;
