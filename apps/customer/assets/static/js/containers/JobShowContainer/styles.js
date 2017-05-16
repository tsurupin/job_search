import styled from 'styled-components';
import fonts from 'styles/fonts';
import colors from 'styles/colors';

export const Wrapper = styled.article`

`;

export const Heading = styled.div`
  margin-bottom: 30px;
  padding-bottom: 10px;
  border-bottom: 1px solid ${colors.listBorderColor};
`;

export const TitleLink = styled.a`
  ${fonts('font-title')}
  line-height: 1.12;
  color: ${colors.textColor};
  letter-spacing: -.022em;
  font-weight: 700;
  cursor: pointer
`;

export const Content = styled.div`
  
`;


export const Description = styled.div`
  padding-bottom: 30px;
  border-bottom: 1px solid #f3f3f3;
  font-size: 1.8rem;
  font-family: Georgia,Cambria,Times New Roman,Times,serif;
  font-size: 2.1rem;
  color: rgba(0,0,0,0.8);
  font-weight: 400;
  line-height: 1.58;
  letter-spacing: -.003em;  
`;

export const FavoriteButtonWrapper = styled.div`
  display: flex;
  justify-content: flex-end;
  margin-top: 15px;
`;
